<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    OffreStage offre = (OffreStage) request.getAttribute("offre");
    List<QuizQuestion> quizQuestions = (List<QuizQuestion>) request.getAttribute("quizQuestions");
    
    if (user == null || offre == null) {
        response.sendRedirect("offres");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postuler - <%= offre.getTitre() %></title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>Postuler a une offre</h1>
        </div>
        
        <div class="card">
            <div class="card-body">
                <!-- Offer Summary -->
                <div class="offer-summary mb-xl">
                    <div class="offer-header">
                        <h2><%= offre.getTitre() %></h2>
                        <span class="badge badge-<%= offre.getTypeStage().equals("Apprentissage") ? "primary" : "secondary" %>">
                            <%= offre.getTypeStage() %>
                        </span>
                    </div>
                    
                    <p class="entreprise-name mb-lg"><strong><%= offre.getEntrepriseName() %></strong></p>
                    
                    <div class="offer-info-grid mb-lg">
                        <div class="info-item">
                            <strong>Spécialité :</strong>
                            <span><%= offre.getSpecialite() %></span>
                        </div>
                        <div class="info-item">
                            <strong>Zone géographique :</strong>
                            <span><%= offre.getZoneGeographique() %></span>
                        </div>
                        <div class="info-item">
                            <strong>Durée :</strong>
                            <span><%= offre.getDureeMois() %> mois</span>
                        </div>
                        <% if (offre.getRemuneration() != null && !offre.getRemuneration().isEmpty()) { %>
                            <div class="info-item">
                                <strong>Rémunération :</strong>
                                <span><%= offre.getRemuneration() %></span>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="offer-description-full mb-lg">
                        <strong>Description :</strong>
                        <p><%= offre.getDescription() %></p>
                    </div>
                    
                    <% if (offre.getCompetencesRequises() != null && !offre.getCompetencesRequises().isEmpty()) { %>
                        <div class="offer-competences">
                            <strong>Compétences requises :</strong>
                            <p><%= offre.getCompetencesRequises() %></p>
                        </div>
                    <% } %>
                </div>
                
                <hr class="my-xl">
                
                <!-- Application Form -->
                <form action="candidature" method="post" class="application-form">
                    <input type="hidden" name="offreId" value="<%= offre.getId() %>">
                    
                    <h3 class="mb-lg">Votre Candidature</h3>
                    
                    <!-- Letter of Motivation -->
                    <div class="form-group">
                        <label for="lettreMotivation">Lettre de motivation *</label>
                        <textarea id="lettreMotivation" name="lettreMotivation" rows="8" required
                                  placeholder="Expliquez pourquoi vous êtes intéressé(e) par cette offre (minimum 50 mots)..."></textarea>
                        <small class="form-text" id="wordCountText">Minimum 50 mots requis (0 mots actuellement)</small>
                        <div id="wordCountError" class="error-message" style="display: none;">
                            <strong>Erreur :</strong> <span id="wordCountErrorText"></span>
                        </div>
                    </div>
                    
                    <!-- Quiz Section (if offer has quiz) -->
                    <% if (quizQuestions != null && !quizQuestions.isEmpty()) { %>
                        <hr class="my-xl">
                        
                        <div class="quiz-section">
                            <div class="quiz-header-inline">
                                <h3>Quiz de Competences</h3>
                                <span class="badge badge-warning">Obligatoire</span>
                            </div>
                            <p class="text-muted mb-lg">Veuillez repondre a toutes les questions ci-dessous. Score minimum requis: 75%</p>
                            
                            <% for (int i = 0; i < quizQuestions.size(); i++) {
                                QuizQuestion question = quizQuestions.get(i); %>
                                <div class="quiz-question mb-lg">
                                    <p class="question-text">
                                        <strong>Question <%= (i + 1) %> :</strong> <%= question.getQuestionText() %>
                                    </p>
                                    <div class="quiz-options">
                                        <label class="radio-label">
                                            <input type="radio" name="q<%= question.getId() %>" value="a" required>
                                            A) <%= question.getOptionA() %>
                                        </label>
                                        <label class="radio-label">
                                            <input type="radio" name="q<%= question.getId() %>" value="b">
                                            B) <%= question.getOptionB() %>
                                        </label>
                                        <label class="radio-label">
                                            <input type="radio" name="q<%= question.getId() %>" value="c">
                                            C) <%= question.getOptionC() %>
                                        </label>
                                        <label class="radio-label">
                                            <input type="radio" name="q<%= question.getId() %>" value="d">
                                            D) <%= question.getOptionD() %>
                                        </label>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                    
                    <div class="form-actions mt-xl">
                        <button type="submit" class="btn btn-primary btn-lg">
                            Envoyer ma candidature
                        </button>
                        <a href="offres" class="btn btn-secondary">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Validate letter of motivation (minimum 50 words)
        document.querySelector('.application-form').addEventListener('submit', function(e) {
            const lettre = document.getElementById('lettreMotivation').value.trim();
            const wordCount = lettre.split(/\s+/).filter(word => word.length > 0).length;
            const errorDiv = document.getElementById('wordCountError');
            const errorText = document.getElementById('wordCountErrorText');
            
            if (wordCount < 50) {
                e.preventDefault();
                errorText.textContent = 'Votre lettre de motivation doit contenir au moins 50 mots. Actuellement: ' + wordCount + ' mots.';
                errorDiv.style.display = 'block';
                document.getElementById('lettreMotivation').scrollIntoView({ behavior: 'smooth', block: 'center' });
                return false;
            }
            errorDiv.style.display = 'none';
            return true;
        });
        
        // Real-time word count
        document.getElementById('lettreMotivation').addEventListener('input', function() {
            const words = this.value.trim().split(/\s+/).filter(word => word.length > 0).length;
            const small = document.getElementById('wordCountText');
            const errorDiv = document.getElementById('wordCountError');
            
            small.textContent = 'Minimum 50 mots requis (' + words + ' mots actuellement)';
            small.style.color = words >= 50 ? 'var(--color-success)' : 'var(--color-text-muted)';
            
            // Hide error message when user starts typing
            if (errorDiv.style.display === 'block') {
                errorDiv.style.display = 'none';
            }
        });
    </script>
</body>
</html>
