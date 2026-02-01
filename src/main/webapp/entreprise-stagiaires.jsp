<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
    if (entreprise == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Candidature> stagiaires = (List<Candidature>) request.getAttribute("stagiaires");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nos Stagiaires - StageConnect</title>
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
            <h1>Nos Stagiaires</h1>
            <p>Liste des stagiaires acceptes dans votre entreprise</p>
        </div>
        
        <div class="card">
            <div class="card-body">
                <% if (stagiaires != null && !stagiaires.isEmpty()) { %>
                    <div class="offers-grid">
                        <% for (Candidature stagiaire : stagiaires) { %>
                            <div class="entreprise-card">
                                <div class="entreprise-header">
                                    <h3><%= stagiaire.getApprenantFullName() %></h3>
                                </div>
                                <div class="entreprise-details mb-md">
                                    <div class="detail-item">
                                        <strong>Email:</strong> <%= stagiaire.getApprenantEmail() %>
                                    </div>
                                    <div class="detail-item">
                                        <strong>Offre:</strong> <%= stagiaire.getOffreTitre() %>
                                    </div>
                                    <div class="detail-item">
                                        <strong>Date candidature:</strong> <%= sdf.format(stagiaire.getDateCandidature()) %>
                                    </div>
                                    <% if (stagiaire.getDateReponse() != null) { %>
                                        <div class="detail-item">
                                            <strong>Accepté le:</strong> <%= sdf.format(stagiaire.getDateReponse()) %>
                                        </div>
                                    <% } %>
                                </div>
                                <button onclick="viewDetails(<%= stagiaire.getId() %>)" class="btn btn-primary btn-block">
                                    Voir détails
                                </button>
                                
                                <!-- Hidden details -->
                                <div id="details-<%= stagiaire.getId() %>" class="details-row mt-lg" style="display: none; padding-top: var(--spacing-lg); border-top: 1px solid var(--color-border-light);">
                                    <% if (stagiaire.getLettreMotivation() != null && !stagiaire.getLettreMotivation().isEmpty()) { %>
                                        <div class="mb-md">
                                            <strong>Lettre de motivation:</strong>
                                            <p class="text-secondary">
                                                <%= stagiaire.getLettreMotivation() %>
                                            </p>
                                        </div>
                                    <% } %>
                                    <% if (stagiaire.getCommentaireAdmin() != null && !stagiaire.getCommentaireAdmin().isEmpty()) { %>
                                        <div>
                                            <strong>Commentaire:</strong>
                                            <p class="text-secondary">
                                                <%= stagiaire.getCommentaireAdmin() %>
                                            </p>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">
                        Vous n'avez pas encore accepté de stagiaires. 
                        Consultez <a href="entreprise-dashboard">vos candidatures</a> pour en accepter.
                    </p>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function viewDetails(id) {
            const details = document.getElementById('details-' + id);
            if (details.style.display === 'none') {
                details.style.display = 'block';
            } else {
                details.style.display = 'none';
            }
        }
    </script>
</body>
</html>
