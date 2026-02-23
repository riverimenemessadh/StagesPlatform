package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.dao.OffreStageDAO;
import com.stages.dao.QuizDAO;
import com.stages.dao.QuizAttemptDAO;
import com.stages.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/candidature")
public class CandidatureServlet extends HttpServlet {
    private CandidatureDAO candidatureDAO;
    private OffreStageDAO offreDAO;
    private QuizDAO quizDAO;
    private QuizAttemptDAO quizAttemptDAO;
    
    @Override
    public void init() {
        candidatureDAO = new CandidatureDAO();
        offreDAO = new OffreStageDAO();
        quizDAO = new QuizDAO();
        quizAttemptDAO = new QuizAttemptDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("apply".equals(action)) {
            // Show application form
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null) {
                int offreId = Integer.parseInt(offreIdStr);
                
                // Check if already applied
                if (candidatureDAO.hasApplied(user.getId(), offreId)) {
                    session.setAttribute("error", "Vous avez deja postule a cette offre");
                    response.sendRedirect("offres");
                    return;
                }
                
                OffreStage offre = offreDAO.getOffreById(offreId);
                request.setAttribute("offre", offre);
                
                // If offer has quiz, load quiz questions
                if (offre.hasQuiz()) {
                    List<QuizQuestion> questions = quizDAO.getQuestionsByQuizId(offre.getQuizId());
                    request.setAttribute("quizQuestions", questions);
                }
                
                request.getRequestDispatcher("apply.jsp").forward(request, response);
            }
        } else {
            // Show all applications
            List<Candidature> candidatures = candidatureDAO.getCandidaturesByApprenant(user.getId());
            request.setAttribute("candidatures", candidatures);
            request.getRequestDispatcher("mes-candidatures.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String offreIdStr = request.getParameter("offreId");
        String lettreMotivation = request.getParameter("lettreMotivation");
        
        if (offreIdStr == null || offreIdStr.isEmpty()) {
            response.sendRedirect("offres");
            return;
        }
        
        int offreId = Integer.parseInt(offreIdStr);
        
        // Check if already applied
        if (candidatureDAO.hasApplied(user.getId(), offreId)) {
            session.setAttribute("error", "Vous avez deja postule a cette offre");
            response.sendRedirect("offres");
            return;
        }
        
        OffreStage offre = offreDAO.getOffreById(offreId);
        Integer quizAttemptId = null;
        Double quizScore = null;
        
        // Handle quiz submission if offer has quiz
        if (offre.hasQuiz()) {
            List<QuizQuestion> questions = quizDAO.getQuestionsByQuizId(offre.getQuizId());
            Quiz quiz = quizDAO.getQuizById(offre.getQuizId());
            
            int totalPoints = 0;
            int earnedPoints = 0;
            List<QuizResponse> responses = new ArrayList<>();
            
            // Calculate score
            for (QuizQuestion question : questions) {
                String selectedAnswer = request.getParameter("q" + question.getId());
                boolean isCorrect = (selectedAnswer != null && selectedAnswer.equals(question.getCorrectAnswer()));
                int pointsEarned = isCorrect ? question.getPoints() : 0;
                
                QuizResponse responseObj = new QuizResponse();
                responseObj.setQuestionId(question.getId());
                responseObj.setSelectedAnswer(selectedAnswer);
                responseObj.setCorrect(isCorrect);
                responseObj.setPointsEarned(pointsEarned);
                responses.add(responseObj);
                
                totalPoints += question.getPoints();
                earnedPoints += pointsEarned;
            }
            
            quizScore = (totalPoints > 0) ? ((double) earnedPoints / totalPoints) * 100 : 0;
            boolean passed = (quizScore >= quiz.getPassingScore());
            
            // Create quiz attempt
            QuizAttempt attempt = new QuizAttempt();
            attempt.setQuizId(offre.getQuizId());
            attempt.setApprenantId(user.getId());
            attempt.setOffreId(offreId);
            attempt.setScore(quizScore);
            attempt.setTotalPoints(totalPoints);
            attempt.setEarnedPoints(earnedPoints);
            attempt.setPassed(passed);
            
            quizAttemptId = quizAttemptDAO.createAttempt(attempt);
            
            // Save individual responses
            if (quizAttemptId > 0) {
                for (QuizResponse responseObj : responses) {
                    responseObj.setAttemptId(quizAttemptId);
                    quizAttemptDAO.saveResponse(responseObj);
                }
            }
        }
        
        // Create candidature
        Candidature candidature = new Candidature(user.getId(), offreId);
        candidature.setLettreMotivation(lettreMotivation);
        candidature.setQuizAttemptId(quizAttemptId);
        candidature.setQuizScore(quizScore);
        
        if (candidatureDAO.createCandidature(candidature)) {
            session.setAttribute("success", "Votre candidature a ete enregistree avec succes !");
            response.sendRedirect("candidature");
        } else {
            session.setAttribute("error", "Erreur lors de l'envoi de la candidature");
            response.sendRedirect("offres");
        }
    }
}
