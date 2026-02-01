<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Candidature> candidatures = (List<Candidature>) request.getAttribute("candidatures");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Candidatures - StageConnect</title>
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
            <h1>Mes Candidatures</h1>
            <p>Suivez l'etat de vos candidatures</p>
        </div>
        
        <% if (candidatures != null && !candidatures.isEmpty()) { %>
            <div class="applications-grid">
                <% for (Candidature c : candidatures) { %>
                    <div class="application-card">
                        <div class="application-header">
                            <h3><%= c.getOffreTitre() %></h3>
                            <span class="status-badge status-<%= c.getStatut().toLowerCase().replace(" ", "-").replace("é", "e") %>">
                                <%= c.getStatut() %>
                            </span>
                        </div>
                        
                        <div class="application-details">
                            <p><strong>Entreprise :</strong> <%= c.getEntrepriseName() %></p>
                            <p><strong>Date de candidature :</strong> <%= sdf.format(c.getDateCandidature()) %></p>
                            
                            <% if (c.getDateReponse() != null) { %>
                                <p><strong>Date de réponse :</strong> <%= sdf.format(c.getDateReponse()) %></p>
                            <% } %>
                            
                            <% if (c.getCommentaireAdmin() != null && !c.getCommentaireAdmin().isEmpty()) { %>
                                <div class="admin-comment">
                                    <strong>Commentaire :</strong>
                                    <p><%= c.getCommentaireAdmin() %></p>
                                </div>
                            <% } %>
                            
                            <% if (c.getLettreMotivation() != null && !c.getLettreMotivation().isEmpty()) { %>
                                <details class="motivation-letter">
                                    <summary>Voir ma lettre de motivation</summary>
                                    <p><%= c.getLettreMotivation() %></p>
                                </details>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results">
                <p>Vous n'avez pas encore postulé à des offres.</p>
                <a href="offres" class="btn btn-primary">Parcourir les offres</a>
            </div>
        <% } %>
    </div>
</body>
</html>