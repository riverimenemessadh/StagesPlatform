<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="false" %>
<%@ page import="com.stages.model.*, com.stages.dao.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    // Test page to diagnose issues
    try {
        Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
        if (entreprise == null) {
            out.println("No entreprise in session");
            response.sendRedirect("login");
            return;
        }
        
        out.println("<h1>Debug Info</h1>");
        out.println("<p>Entreprise ID: " + entreprise.getId() + "</p>");
        out.println("<p>Entreprise Name: " + entreprise.getNom() + "</p>");
        
        List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
        out.println("<p>Offres is null: " + (offres == null) + "</p>");
        
        if (offres != null) {
            out.println("<p>Offres count: " + offres.size() + "</p>");
            
            QuizDAO quizDAO = new QuizDAO();
            out.println("<p>QuizDAO initialized successfully</p>");
            
            for (OffreStage offre : offres) {
                out.println("<h3>Offre: " + offre.getTitre() + "</h3>");
                out.println("<p>Has Quiz: " + offre.hasQuiz() + "</p>");
                
                if (offre.hasQuiz() && offre.getQuizId() != null) {
                    out.println("<p>Quiz ID: " + offre.getQuizId() + "</p>");
                    
                    try {
                        List<QuizQuestion> questions = quizDAO.getQuestionsByQuizId(offre.getQuizId());
                        out.println("<p>Questions is null: " + (questions == null) + "</p>");
                        if (questions != null) {
                            out.println("<p>Questions count: " + questions.size() + "</p>");
                            
                            for (QuizQuestion q : questions) {
                                out.println("<p>Question: " + (q.getQuestionText() != null ? q.getQuestionText() : "NULL") + "</p>");
                            }
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red'>Error loading questions: " + e.getMessage() + "</p>");
                        e.printStackTrace(new java.io.PrintWriter(out));
                    }
                }
            }
        }
        
        out.println("<h2>Test Complete</h2>");
        
    } catch (Exception e) {
        out.println("<h1 style='color:red'>ERROR:</h1>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
%>
