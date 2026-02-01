<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Candidature> candidatures = (List<Candidature>) request.getAttribute("candidatures");
    List<OffreStage> recentOffres = (List<OffreStage>) request.getAttribute("recentOffres");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    int totalStudents = (Integer) request.getAttribute("totalStudents");
    int totalEntreprises = (Integer) request.getAttribute("totalEntreprises");
    int totalCandidatures = (Integer) request.getAttribute("totalCandidatures");
    int totalOffres = (Integer) request.getAttribute("totalOffres");
    
    String selectedStatut = (String) request.getAttribute("selectedStatut");
    if (selectedStatut == null || selectedStatut.isEmpty()) {
        selectedStatut = "all";
    }
    String searchTerm = (String) request.getAttribute("searchTerm");
    if (searchTerm == null) {
        searchTerm = "";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration - StageConnect</title>
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
            <h1>Tableau de bord Administration</h1>
            <p>Vue d'ensemble de la plateforme</p>
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
        
        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Apprenant</h3>
                <p><%= totalStudents %></p>
            </div>
            <div class="stat-card">
                <h3>Total Entreprises</h3>
                <p><%= totalEntreprises %></p>
            </div>
            <div class="stat-card">
                <h3>Total Candidatures</h3>
                <p><%= totalCandidatures %></p>
            </div>
            <div class="stat-card">
                <h3>Offres</h3>
                <p><%= totalOffres %></p>
            </div>
        </div>
        
        <!-- Search and Filter -->
        <div class="card filter-card">
            <div class="card-body">
                <form action="admin" method="get" class="filter-form" id="filterForm">
                    <div class="filter-row">
                        <div>
                            <label for="search">Rechercher :</label>
                            <input type="text" id="search" name="search" 
                                   placeholder="Nom, email, offre, entreprise..." 
                                   value="<%= searchTerm %>">
                        </div>
                        <div>
                            <label for="statut">Filtrer par statut :</label>
                            <select id="statut" name="statut" onchange="document.getElementById('filterForm').submit();">
                                <option value="all" <%= "all".equals(selectedStatut) ? "selected" : "" %>>
                                    Tous les statuts
                                </option>
                                <option value="En attente" <%= "En attente".equals(selectedStatut) ? "selected" : "" %>>
                                    En attente
                                </option>
                                <option value="Acceptée" <%= "Acceptée".equals(selectedStatut) ? "selected" : "" %>>
                                    Acceptée
                                </option>
                                <option value="Refusée" <%= "Refusée".equals(selectedStatut) ? "selected" : "" %>>
                                    Refusée
                                </option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Rechercher</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Applications Table -->
        <div class="card">
            <div class="card-body">
                <div class="card-header">
                    <h2>Dernieres Candidatures</h2>
                    <a href="admin-candidatures" class="btn btn-secondary">Voir toutes les candidatures</a>
                </div>
                <% if (candidatures != null && !candidatures.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Apprenant</th>
                                    <th>Email</th>
                                    <th>Offre</th>
                                    <th>Entreprise</th>
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
                                        <td><%= c.getEntrepriseName() %></td>
                                        <td><%= sdf.format(c.getDateCandidature()) %></td>
                                        <td>
                                            <span class="status-badge status-<%= c.getStatut().toLowerCase().replace(" ", "-").replace("é", "e") %>">
                                                <%= c.getStatut() %>
                                            </span>
                                        </td>
                                        <td class="actions-cell">
                                            <button onclick="viewDetails(<%= c.getId() %>)" class="btn btn-sm btn-secondary">
                                                Voir Details
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Hidden details row -->
                                    <tr id="details-<%= c.getId() %>" class="details-row">
                                        <td colspan="7">
                                            <div class="application-details-admin">
                                                <h4>Détails de la candidature</h4>
                                                <% if (c.getLettreMotivation() != null && !c.getLettreMotivation().isEmpty()) { %>
                                                    <div class="detail-section">
                                                        <strong>Lettre de motivation :</strong>
                                                        <p><%= c.getLettreMotivation() %></p>
                                                    </div>
                                                <% } %>
                                                <% if (c.getCommentaireAdmin() != null && !c.getCommentaireAdmin().isEmpty()) { %>
                                                    <div class="detail-section">
                                                        <strong>Commentaire Administration :</strong>
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
                    <p class="text-center text-muted">Aucune candidature à afficher.</p>
                <% } %>
            </div>
        </div>
        
        <!-- Recent Offers -->
        <div class="card mt-xl">
            <div class="card-header">
                <h2>Dernieres Offres Publiées</h2>
                <a href="admin-offres" class="btn btn-secondary">Voir toutes les offres</a>
            </div>
            <div class="card-body">
                <% if (recentOffres != null && !recentOffres.isEmpty()) { %>
                    <div class="offers-grid">
                        <% for (OffreStage offre : recentOffres) { %>
                            <div class="offer-card">
                                <div class="offer-header">
                                    <h3><%= offre.getTitre() %></h3>
                                </div>
                                <div class="offer-details">
                                    <div class="detail-item"><strong>Entreprise:</strong> <%= offre.getEntrepriseName() %></div>
                                    <div class="detail-item"><strong>Spécialité:</strong> <%= offre.getSpecialite() %></div>
                                    <div class="detail-item"><strong>Zone:</strong> <%= offre.getZoneGeographique() %></div>
                                    <div class="detail-item text-muted">
                                        Publié le <%= sdf.format(offre.getCreatedAt()) %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">Aucune offre à afficher.</p>
                <% } %>
            </div>
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
    </script>
</body>
</html>
