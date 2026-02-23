<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, com.stages.dao.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
    if (entreprise == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Candidature> candidatures = (List<Candidature>) request.getAttribute("candidatures");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Initialize DAOs for quiz data
    QuizDAO quizDAO = new QuizDAO();
    QuizAttemptDAO quizAttemptDAO = new QuizAttemptDAO();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord Entreprise - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="includes/navbar-entreprise.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>Candidatures Recues</h1>
            <p>Gerez les candidatures pour vos offres de stage</p>
        </div>
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Status Filter -->
        <div class="card filter-card">
            <div class="card-body">
                <form action="entreprise-dashboard" method="get" class="filter-form">
                    <div class="filter-row">
                        <label for="statut">Filtrer par statut :</label>
                        <select id="statut" name="statut" onchange="this.form.submit()">
                            <option value="all" <%= "all".equals(request.getAttribute("selectedStatut")) ? "selected" : "" %>>
                                Tous les statuts
                            </option>
                            <option value="En attente" <%= "En attente".equals(request.getAttribute("selectedStatut")) ? "selected" : "" %>>
                                En attente
                            </option>
                            <option value="Acceptée" <%= "Acceptée".equals(request.getAttribute("selectedStatut")) ? "selected" : "" %>>
                                Acceptée
                            </option>
                            <option value="Refusée" <%= "Refusée".equals(request.getAttribute("selectedStatut")) ? "selected" : "" %>>
                                Refusée
                            </option>
                        </select>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Applications Table -->
        <div class="card">
            <div class="card-body">
                <% if (candidatures != null && !candidatures.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Apprenant</th>
                                    <th>Email</th>
                                    <th>Offre</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Candidature c : candidatures) { %>
                                    <tr>
                                        <td><%= c.getApprenantFullName() %></td>
                                        <td><%= c.getApprenantEmail() %></td>
                                        <td><%= c.getOffreTitre() %></td>
                                        <td><%= sdf.format(c.getDateCandidature()) %></td>
                                        <td>
                                            <span class="status-badge status-<%= c.getStatut().toLowerCase().replace(" ", "-").replace("é", "e") %>">
                                                <%= c.getStatut() %>
                                            </span>
                                        </td>
                                        <td class="actions-cell">
                                            <% if ("En attente".equals(c.getStatut())) { %>
                                                <button onclick="openModal(<%= c.getId() %>, 'accept')" 
                                                        class="btn btn-sm btn-success">
                                                    ✓ Accepter
                                                </button>
                                                <button onclick="openModal(<%= c.getId() %>, 'reject')" 
                                                        class="btn btn-sm btn-danger">
                                                    ✗ Refuser
                                                </button>
                                            <% } else { %>
                                                <span class="text-muted">Traitée</span>
                                            <% } %>
                                            <button onclick="viewDetails(<%= c.getId() %>)" class="btn btn-sm btn-secondary">
                                                Details
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Hidden details row -->
                                    <tr id="details-<%= c.getId() %>" class="details-row">
                                        <td colspan="6">
                                            <div class="application-details-admin">
                                                <h4>Détails de la candidature</h4>
                                                
                                                <% if (c.getQuizAttemptId() != null && c.getQuizAttemptId() > 0) { 
                                                    QuizAttempt attempt = quizAttemptDAO.getAttemptById(c.getQuizAttemptId());
                                                    if (attempt != null) {
                                                        List<QuizResponse> responses = quizAttemptDAO.getResponsesByAttemptId(c.getQuizAttemptId());
                                                        if (responses != null && !responses.isEmpty()) {
                                                %>
                                                    <div class="detail-section quiz-result-section">
                                                        <strong>Résultat du Quiz :</strong>
                                                        <div class="quiz-score-display mb-md">
                                                            <span class="score-badge <%= attempt.getScore() >= 75 ? "badge-success" : "badge-danger" %>">
                                                                <%= String.format("%.1f", attempt.getScore()) %>%
                                                            </span>
                                                            <span class="text-muted">
                                                                (<%= attempt.getEarnedPoints() %> / <%= attempt.getTotalPoints() %> points)
                                                            </span>
                                                        </div>
                                                        
                                                        <div class="quiz-answers-inline">
                                                            <h5>Réponses du candidat:</h5>
                                                            <% for (int i = 0; i < responses.size(); i++) {
                                                                QuizResponse resp = responses.get(i);
                                                                if (resp != null && resp.getQuestionId() > 0) {
                                                                    QuizQuestion question = quizDAO.getQuestionById(resp.getQuestionId());
                                                                    if (question != null && resp.getSelectedAnswer() != null) { 
                                                                        String selectedAnswer = resp.getSelectedAnswer();
                                                                        String correctAnswer = question.getCorrectAnswer() != null ? question.getCorrectAnswer() : "";
                                                            %>
                                                                <div class="quiz-answer-item <%= resp.isCorrect() ? "correct" : "incorrect" %>">
                                                                    <p class="question-text"><strong>Q<%= (i + 1) %>:</strong> <%= question.getQuestionText() != null ? question.getQuestionText() : "" %></p>
                                                                    <p class="student-answer">
                                                                        <strong>Réponse:</strong> 
                                                                        <span class="<%= resp.isCorrect() ? "text-success" : "text-danger" %>">
                                                                            <%= selectedAnswer.toUpperCase() %>) <%= question.getOptionByLetter(selectedAnswer) %>
                                                                        </span>
                                                                    </p>
                                                                    <% if (!resp.isCorrect() && !correctAnswer.isEmpty()) { %>
                                                                        <p class="correct-answer">
                                                                            <strong>Correct:</strong> 
                                                                            <span class="text-success">
                                                                                <%= correctAnswer.toUpperCase() %>) <%= question.getOptionByLetter(correctAnswer) %>
                                                                            </span>
                                                                        </p>
                                                                    <% } %>
                                                                </div>
                                                            <% 
                                                                    }
                                                                }
                                                            } %>
                                                        </div>
                                                    </div>
                                                <% 
                                                        }
                                                    }
                                                } %>
                                                
                                                <% if (c.getLettreMotivation() != null && !c.getLettreMotivation().isEmpty()) { %>
                                                    <div class="detail-section">
                                                        <strong>Lettre de motivation :</strong>
                                                        <p><%= c.getLettreMotivation() %></p>
                                                    </div>
                                                <% } %>
                                                <% if (c.getCommentaireAdmin() != null && !c.getCommentaireAdmin().isEmpty()) { %>
                                                    <div class="detail-section">
                                                        <strong>Commentaire :</strong>
                                                        <p><%= c.getCommentaireAdmin() %></p>
                                                    </div>
                                                <% } %>
                                                <% if (c.getDateReponse() != null) { %>
                                                    <div class="detail-section">
                                                        <strong>Date de réponse :</strong>
                                                        <p><%= sdf.format(c.getDateReponse()) %></p>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">Aucune candidature reçue pour le moment.</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Modal for Accept/Reject -->
    <div id="actionModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">Confirmer l'action</h2>
            <form action="entreprise-dashboard" method="post">
                <input type="hidden" id="candidatureId" name="candidatureId">
                <input type="hidden" id="action" name="action">
                
                <div class="form-group">
                    <label for="commentaire">Commentaire (optionnel) :</label>
                    <textarea id="commentaire" name="commentaire" rows="4"
                              placeholder="Ajoutez un commentaire pour le candidat..."></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="submit" class="btn btn-primary" id="confirmBtn">Confirmer</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function viewDetails(id) {
            const row = document.getElementById('details-' + id);
            if (row.style.display === 'none') {
                row.style.display = 'table-row';
            } else {
                row.style.display = 'none';
            }
        }
        
        function openModal(candidatureId, action) {
            document.getElementById('candidatureId').value = candidatureId;
            document.getElementById('action').value = action;
            
            const modal = document.getElementById('actionModal');
            const title = document.getElementById('modalTitle');
            const btn = document.getElementById('confirmBtn');
            
            if (action === 'accept') {
                title.textContent = 'Accepter la candidature';
                btn.textContent = 'Accepter';
                btn.className = 'btn btn-success';
            } else {
                title.textContent = 'Refuser la candidature';
                btn.textContent = 'Refuser';
                btn.className = 'btn btn-danger';
            }
            
            modal.style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('actionModal').style.display = 'none';
            document.getElementById('commentaire').value = '';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('actionModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
