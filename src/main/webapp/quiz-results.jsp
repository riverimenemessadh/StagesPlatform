<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, com.stages.dao.*, java.util.*" %>
<%
    // Get attemptId from request
    String attemptIdStr = request.getParameter("attemptId");
    if (attemptIdStr == null) {
        response.sendRedirect("entreprise-dashboard");
        return;
    }
    
    int attemptId = Integer.parseInt(attemptIdStr);
    
    // Load quiz attempt and responses
    QuizAttemptDAO quizAttemptDAO = new QuizAttemptDAO();
    QuizDAO quizDAO = new QuizDAO();
    
    QuizAttempt attempt = quizAttemptDAO.getAttemptById(attemptId);
    if (attempt == null) {
        response.sendRedirect("entreprise-dashboard");
        return;
    }
    
    Quiz quiz = quizDAO.getQuizById(attempt.getQuizId());
    List<QuizResponse> responses = quizAttemptDAO.getResponsesByAttemptId(attemptId);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats du Quiz - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container quiz-results-container">
        <div class="page-header">
            <h1>Résultats du Quiz</h1>
        </div>
        
        <!-- Score Banner -->
        <div class="quiz-score-banner <%= attempt.isPassed() ? "" : "failed" %>">
            <div class="score-display"><%= String.format("%.0f", attempt.getScore()) %>%</div>
            <div class="score-label">
                <%= attempt.getEarnedPoints() %> / <%= attempt.getTotalPoints() %> points
                - <%= attempt.isPassed() ? "Reussi" : "Non reussi" %>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body">
                <h2 class="mb-lg"><%= quiz.getTitre() %></h2>
                
                <!-- Question Results -->
                <% for (QuizResponse resp : responses) {
                    QuizQuestion question = quizDAO.getQuestionById(resp.getQuestionId());
                    if (question != null) { %>
                    <div class="quiz-result-item <%= resp.isCorrect() ? "border-success" : "border-danger" %>">
                        <p class="question-text"><strong><%= question.getQuestionText() %></strong></p>
                        
                        <div class="mb-md">
                            <strong>Reponse du candidat :</strong>
                            <span class="<%= resp.isCorrect() ? "text-success" : "text-danger" %>">
                                <%= resp.getSelectedAnswer().toUpperCase() %>) <%= question.getOptionByLetter(resp.getSelectedAnswer()) %>
                            </span>
                        </div>
                        
                        <% if (!resp.isCorrect()) { %>
                            <div>
                                <strong>Reponse correcte :</strong>
                                <span class="text-success">
                                    <%= question.getCorrectAnswer().toUpperCase() %>) <%= question.getOptionByLetter(question.getCorrectAnswer()) %>
                                </span>
                            </div>
                        <% } %>
                        
                        <div class="mt-sm">
                            <small class="text-muted">
                                Points: <%= resp.getPointsEarned() %> / <%= question.getPoints() %>
                            </small>
                        </div>
                    </div>
                    <% }
                } %>
                
                <div class="form-actions mt-xl">
                    <button onclick="window.close()" class="btn btn-secondary">Fermer</button>
                    <button onclick="window.print()" class="btn btn-primary">Imprimer</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
