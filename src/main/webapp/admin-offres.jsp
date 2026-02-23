<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, com.stages.dao.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Entreprise> entreprises = (List<Entreprise>) request.getAttribute("entreprises");
    Entreprise selectedEntreprise = (Entreprise) request.getAttribute("selectedEntreprise");
    List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    // Initialize DAO for quiz data
    QuizDAO quizDAO = new QuizDAO();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offres des Entreprises - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="includes/navbar-admin.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>Offres des Entreprises</h1>
            <p>Voir les entreprises et leurs offres de stage</p>
        </div>
        
        <% if (selectedEntreprise == null) { %>
            <!-- List of all enterprises -->
            <div class="card">
            <div class="card-header">
                <h2>Entreprises</h2>
            </div>
            <div class="card-body">
                    <% if (entreprises != null && !entreprises.isEmpty()) { %>
                        <div class="offers-grid">
                            <% for (Entreprise ent : entreprises) { %>
                                <div class="entreprise-card">
                                    <div class="entreprise-header">
                                        <h3><%= ent.getNom() %></h3>
                                    </div>
                                    <div class="entreprise-details">
                                        <% if (ent.getSecteur() != null) { %>
                                            <div class="detail-item">
                                                <strong>Secteur:</strong> <%= ent.getSecteur() %>
                                            </div>
                                        <% } %>
                                        <% if (ent.getZoneGeographique() != null) { %>
                                            <div class="detail-item">
                                                <strong>Zone:</strong> <%= ent.getZoneGeographique() %>
                                            </div>
                                        <% } %>
                                        <% if (ent.getEmail() != null) { %>
                                            <div class="detail-item text-muted">
                                                <%= ent.getEmail() %>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="entreprise-actions">
                                        <a href="admin-offres?entrepriseId=<%= ent.getId() %>" class="btn btn-primary btn-block">
                                            Voir les offres
                                        </a>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p class="text-center text-muted">Aucune entreprise inscrite.</p>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <!-- Enterprise details and offers -->
            <div class="mb-lg">
                <a href="admin-offres" class="btn btn-secondary">← Retour a la liste des entreprises</a>
            </div>
            
            <div class="card mb-lg">
                <div class="card-header">
                    <h2><%= selectedEntreprise.getNom() %></h2>
                </div>
                <div class="card-body">
                    <div class="entreprise-info-grid">
                        <% if (selectedEntreprise.getEmail() != null) { %>
                            <div>
                                <strong>Email:</strong><br>
                                <%= selectedEntreprise.getEmail() %>
                            </div>
                        <% } %>
                        <% if (selectedEntreprise.getTelephone() != null) { %>
                            <div>
                                <strong>Téléphone:</strong><br>
                                <%= selectedEntreprise.getTelephone() %>
                            </div>
                        <% } %>
                        <% if (selectedEntreprise.getSecteur() != null) { %>
                            <div>
                                <strong>Secteur:</strong><br>
                                <%= selectedEntreprise.getSecteur() %>
                            </div>
                        <% } %>
                        <% if (selectedEntreprise.getZoneGeographique() != null) { %>
                            <div>
                                <strong>Zone géographique:</strong><br>
                                <%= selectedEntreprise.getZoneGeographique() %>
                            </div>
                        <% } %>
                        <% if (selectedEntreprise.getAdresse() != null) { %>
                            <div>
                                <strong>Adresse:</strong><br>
                                <%= selectedEntreprise.getAdresse() %>
                            </div>
                        <% } %>
                        <% if (selectedEntreprise.getSiteWeb() != null) { %>
                            <div>
                                <strong>Site web:</strong><br>
                                <a href="<%= selectedEntreprise.getSiteWeb() %>" target="_blank"><%= selectedEntreprise.getSiteWeb() %></a>
                            </div>
                        <% } %>
                    </div>
                    
                    <% if (selectedEntreprise.getDescription() != null && !selectedEntreprise.getDescription().isEmpty()) { %>
                        <div class="mt-xl" style="padding-top: var(--spacing-xl); border-top: 1px solid var(--color-border-main);">
                            <strong>Description:</strong>
                            <p class="text-secondary"><%= selectedEntreprise.getDescription() %></p>
                        </div>
                    <% } %>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h3>Offres de stage</h3>
                </div>
                <div class="card-body">
                    <% if (offres != null && !offres.isEmpty()) { %>
                        <div class="offers-list">
                            <% for (OffreStage offre : offres) { %>
                                <div class="offer-card mb-lg">
                                    <div class="offer-header">
                                        <h4><%= offre.getTitre() %></h4>
                                        <% if (offre.hasQuiz()) { %>
                                            <span class="badge badge-warning">Quiz Requis</span>
                                        <% } %>
                                    </div>
                                    <div class="entreprise-info-grid">
                                        <div>
                                            <strong>Spécialité:</strong> <%= offre.getSpecialite() %>
                                        </div>
                                        <div>
                                            <strong>Type:</strong> <%= offre.getTypeStage() %>
                                        </div>
                                        <div>
                                            <strong>Zone:</strong> <%= offre.getZoneGeographique() %>
                                        </div>
                                        <div>
                                            <strong>Durée:</strong> <%= offre.getDureeMois() %> mois
                                        </div>
                                        <% if (offre.getRemuneration() != null) { %>
                                            <div>
                                                <strong>Rémunération:</strong> <%= offre.getRemuneration() %>
                                            </div>
                                        <% } %>
                                    </div>
                                    <% if (offre.getDescription() != null) { %>
                                        <div class="mt-md">
                                            <strong>Description:</strong>
                                            <p class="text-secondary"><%= offre.getDescription() %></p>
                                        </div>
                                    <% } %>
                                    <% if (offre.hasQuiz()) {
                                        List<QuizQuestion> questions = quizDAO.getQuestionsByQuizId(offre.getQuizId());
                                    %>
                                        <div class="mt-md quiz-display">
                                            <strong>Quiz de Competences:</strong>
                                            <p class="text-muted"><%= questions.size() %> questions - Score minimum: 75%</p>
                                            <button type="button" class="btn btn-sm btn-secondary" onclick="toggleQuizQuestions(<%= offre.getId() %>)">
                                                Voir les questions
                                            </button>
                                            <div id="quiz-<%= offre.getId() %>" class="quiz-questions-display" style="display: none;">
                                                <% for (int i = 0; i < questions.size(); i++) {
                                                    QuizQuestion q = questions.get(i); %>
                                                    <div class="quiz-question-display">
                                                        <p><strong>Q<%= (i + 1) %>:</strong> <%= q.getQuestionText() %></p>
                                                        <ul class="quiz-options-list">
                                                            <li <%= q.getCorrectAnswer().equals("a") ? "class='correct-option'" : "" %>>
                                                                A) <%= q.getOptionA() %>
                                                                <%= q.getCorrectAnswer().equals("a") ? "(Correct)" : "" %>
                                                            </li>
                                                            <li <%= q.getCorrectAnswer().equals("b") ? "class='correct-option'" : "" %>>
                                                                B) <%= q.getOptionB() %>
                                                                <%= q.getCorrectAnswer().equals("b") ? "(Correct)" : "" %>
                                                            </li>
                                                            <li <%= q.getCorrectAnswer().equals("c") ? "class='correct-option'" : "" %>>
                                                                C) <%= q.getOptionC() %>
                                                                <%= q.getCorrectAnswer().equals("c") ? "(Correct)" : "" %>
                                                            </li>
                                                            <li <%= q.getCorrectAnswer().equals("d") ? "class='correct-option'" : "" %>>
                                                                D) <%= q.getOptionD() %>
                                                                <%= q.getCorrectAnswer().equals("d") ? "(Correct)" : "" %>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p class="text-center text-muted">Cette entreprise n'a pas encore publié d'offres.</p>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>
    
    <script>
        function toggleQuizQuestions(offreId) {
            const quizDiv = document.getElementById('quiz-' + offreId);
            if (quizDiv.style.display === 'none') {
                quizDiv.style.display = 'block';
            } else {
                quizDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>
