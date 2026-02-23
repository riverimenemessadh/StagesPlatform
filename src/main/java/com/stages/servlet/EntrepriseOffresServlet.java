package com.stages.servlet;

import com.stages.dao.OffreStageDAO;
import com.stages.dao.QuizDAO;
import com.stages.model.OffreStage;
import com.stages.model.Entreprise;
import com.stages.model.Quiz;
import com.stages.model.QuizQuestion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/entreprise-offres")
public class EntrepriseOffresServlet extends HttpServlet {
    private OffreStageDAO offreStageDAO;
    private QuizDAO quizDAO;
    
    @Override
    public void init() {
        offreStageDAO = new OffreStageDAO();
        quizDAO = new QuizDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
        
        // Get all offers for this entreprise
        List<OffreStage> offres = offreStageDAO.getOffresByEntreprise(entreprise.getId());
        
        // Get all quizzes for this entreprise
        List<Quiz> quizzes = quizDAO.getQuizzesByEntrepriseId(entreprise.getId());
        
        request.setAttribute("offres", offres);
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("entreprise-offres.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            // Edit existing offer
            String offreIdStr = request.getParameter("offreId");
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String specialite = request.getParameter("specialite");
            String typeStage = request.getParameter("typeStage");
            String zone = request.getParameter("zone");
            String dureeMoisStr = request.getParameter("dureeMois");
            String remuneration = request.getParameter("remuneration");
            String competences = request.getParameter("competences");
            String includeQuiz = request.getParameter("includeQuiz");
            
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                int offreId = Integer.parseInt(offreIdStr);
                
                OffreStage offre = offreStageDAO.getOffreById(offreId);
                if (offre != null && offre.getEntrepriseId() == entreprise.getId()) {
                    offre.setTitre(titre);
                    offre.setDescription(description);
                    offre.setSpecialite(specialite);
                    offre.setTypeStage(typeStage);
                    offre.setZoneGeographique(zone);
                    offre.setDureeMois(Integer.parseInt(dureeMoisStr));
                    offre.setRemuneration(remuneration);
                    offre.setCompetencesRequises(competences);
                    
                    // Handle inline quiz creation/update
                    if ("on".equals(includeQuiz) || "true".equals(includeQuiz)) {
                        // Count questions
                        int questionCount = 0;
                        for (int i = 1; i <= 100; i++) {
                            String questionText = request.getParameter("question_" + i);
                            if (questionText != null && !questionText.trim().isEmpty()) {
                                questionCount++;
                            }
                        }
                        
                        if (questionCount >= 3) {
                            // Delete old quiz if exists
                            if (offre.getQuizId() != null && offre.getQuizId() > 0) {
                                quizDAO.deleteQuiz(offre.getQuizId());
                            }
                            
                            // Create new quiz
                            Quiz quiz = new Quiz();
                            quiz.setEntrepriseId(entreprise.getId());
                            quiz.setTitre("Quiz - " + titre);
                            quiz.setDescription("Quiz de competences pour l'offre: " + titre);
                            quiz.setPassingScore(75);
                            
                            int createdQuizId = quizDAO.createQuiz(quiz);
                            
                            if (createdQuizId > 0) {
                                // Create questions
                                int questionOrder = 1;
                                for (int i = 1; i <= 100; i++) {
                                    String questionText = request.getParameter("question_" + i);
                                    if (questionText != null && !questionText.trim().isEmpty()) {
                                        QuizQuestion question = new QuizQuestion();
                                        question.setQuizId(createdQuizId);
                                        question.setQuestionText(questionText.trim());
                                        question.setOptionA(request.getParameter("optionA_" + i));
                                        question.setOptionB(request.getParameter("optionB_" + i));
                                        question.setOptionC(request.getParameter("optionC_" + i));
                                        question.setOptionD(request.getParameter("optionD_" + i));
                                        question.setCorrectAnswer(request.getParameter("correctAnswer_" + i));
                                        
                                        String pointsStr = request.getParameter("points_" + i);
                                        question.setPoints(pointsStr != null && !pointsStr.trim().isEmpty() ? Integer.parseInt(pointsStr) : 5);
                                        question.setQuestionOrder(questionOrder++);
                                        
                                        quizDAO.addQuestion(question);
                                    }
                                }
                                offre.setQuizId(createdQuizId);
                            }
                        } else if (questionCount > 0) {
                            session.setAttribute("error", "Le quiz doit contenir au moins 3 questions");
                            response.sendRedirect("entreprise-offres");
                            return;
                        }
                    }
                    
                    if (offreStageDAO.updateOffre(offre)) {
                        session.setAttribute("success", "Offre modifiée avec succès !");
                    } else {
                        session.setAttribute("error", "Erreur lors de la modification de l'offre");
                    }
                }
            }
        } else if ("create".equals(action)) {
            // Create new offer
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String specialite = request.getParameter("specialite");
            String typeStage = request.getParameter("typeStage");
            String zone = request.getParameter("zone");
            String dureeMoisStr = request.getParameter("dureeMois");
            String remuneration = request.getParameter("remuneration");
            String competences = request.getParameter("competences");
            String includeQuiz = request.getParameter("includeQuiz");
            
            // Validation
            if (titre == null || titre.trim().isEmpty() ||
                specialite == null || specialite.trim().isEmpty() ||
                typeStage == null || typeStage.trim().isEmpty() ||
                zone == null || zone.trim().isEmpty() ||
                dureeMoisStr == null || dureeMoisStr.trim().isEmpty()) {
                session.setAttribute("error", "Tous les champs obligatoires doivent etre remplis");
                response.sendRedirect("entreprise-offres");
                return;
            }
            
            OffreStage offre = new OffreStage();
            offre.setTitre(titre);
            offre.setDescription(description);
            offre.setEntrepriseId(entreprise.getId());
            offre.setSpecialite(specialite);
            offre.setTypeStage(typeStage);
            offre.setZoneGeographique(zone);
            offre.setDureeMois(Integer.parseInt(dureeMoisStr));
            offre.setRemuneration(remuneration);
            offre.setCompetencesRequises(competences);
            offre.setStatut("active");
            
            // Handle inline quiz creation
            Integer createdQuizId = null;
            if ("on".equals(includeQuiz) || "true".equals(includeQuiz)) {
                // Count questions
                int questionCount = 0;
                for (int i = 1; i <= 100; i++) {
                    String questionText = request.getParameter("question_" + i);
                    if (questionText != null && !questionText.trim().isEmpty()) {
                        questionCount++;
                    }
                }
                
                if (questionCount < 3) {
                    session.setAttribute("error", "Le quiz doit contenir au moins 3 questions");
                    response.sendRedirect("entreprise-offres");
                    return;
                }
                
                if (questionCount >= 3) {
                    // Create quiz
                    Quiz quiz = new Quiz();
                    quiz.setEntrepriseId(entreprise.getId());
                    quiz.setTitre("Quiz - " + titre);
                    quiz.setDescription("Quiz de competences pour l'offre: " + titre);
                    quiz.setPassingScore(75);
                    
                    createdQuizId = quizDAO.createQuiz(quiz);
                    
                    if (createdQuizId > 0) {
                        // Create questions
                        int questionOrder = 1;
                        for (int i = 1; i <= 100; i++) {
                            String questionText = request.getParameter("question_" + i);
                            if (questionText != null && !questionText.trim().isEmpty()) {
                                QuizQuestion question = new QuizQuestion();
                                question.setQuizId(createdQuizId);
                                question.setQuestionText(questionText.trim());
                                question.setOptionA(request.getParameter("optionA_" + i));
                                question.setOptionB(request.getParameter("optionB_" + i));
                                question.setOptionC(request.getParameter("optionC_" + i));
                                question.setOptionD(request.getParameter("optionD_" + i));
                                question.setCorrectAnswer(request.getParameter("correctAnswer_" + i));
                                
                                String pointsStr = request.getParameter("points_" + i);
                                question.setPoints(pointsStr != null && !pointsStr.trim().isEmpty() ? Integer.parseInt(pointsStr) : 5);
                                question.setQuestionOrder(questionOrder++);
                                
                                quizDAO.addQuestion(question);
                            }
                        }
                        offre.setQuizId(createdQuizId);
                    }
                } else {
                    session.setAttribute("error", "Le quiz doit contenir au moins 3 questions");
                    response.sendRedirect("entreprise-offres");
                    return;
                }
            }
            
            if (offreStageDAO.createOffre(offre)) {
                session.setAttribute("success", "Offre créée avec succès !");
            } else {
                session.setAttribute("error", "Erreur lors de la création de l'offre");
            }
        } else if ("delete".equals(action)) {
            // Delete offer
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                int offreId = Integer.parseInt(offreIdStr);
                if (offreStageDAO.deleteOffre(offreId)) {
                    session.setAttribute("success", "Offre supprimée avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suppression");
                }
            }
        }
        
        response.sendRedirect("entreprise-offres");
    }
}
