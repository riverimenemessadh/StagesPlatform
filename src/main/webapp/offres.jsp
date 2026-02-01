<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
    List<String> specialites = (List<String>) request.getAttribute("specialites");
    List<String> zones = (List<String>) request.getAttribute("zones");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offres de Stage - StageConnect</title>
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
            <h1>Offres de Stage</h1>
            <p>Trouvez le stage qui vous correspond</p>
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
        
        <!-- Filters -->
        <div class="card filter-card">
            <div class="card-body">
                <form action="offres" method="get" class="filter-form">
                    <div class="filter-row">
                        <div class="form-group">
                            <label for="specialite">Spécialité</label>
                            <select id="specialite" name="specialite" onchange="this.form.submit()">
                                <option value="">Toutes les spécialités</option>
                                <% for (String spec : specialites) { %>
                                    <option value="<%= spec %>" 
                                        <%= spec.equals(request.getAttribute("selectedSpecialite")) ? "selected" : "" %>>
                                        <%= spec %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="zone">Zone</label>
                            <select id="zone" name="zone" onchange="this.form.submit()">
                                <option value="">Toutes les zones</option>
                                <% for (String z : zones) { %>
                                    <option value="<%= z %>" 
                                        <%= z.equals(request.getAttribute("selectedZone")) ? "selected" : "" %>>
                                        <%= z %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="type">Type</label>
                            <select id="type" name="type" onchange="this.form.submit()">
                                <option value="">Tous les types</option>
                                <option value="Présentiel" 
                                    <%= "Présentiel".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>
                                    Présentiel
                                </option>
                                <option value="Apprentissage" 
                                    <%= "Apprentissage".equals(request.getAttribute("selectedType")) ? "selected" : "" %>>
                                    Apprentissage
                                </option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <a href="offres" class="btn btn-secondary">Réinitialiser</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Offers Grid -->
        <div class="offers-grid">
            <% if (offres != null && !offres.isEmpty()) { %>
                <% for (OffreStage offre : offres) { %>
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3><%= offre.getTitre() %></h3>
                            <span class="badge badge-<%= offre.getTypeStage().equals("Apprentissage") ? "primary" : "secondary" %>">
                                <%= offre.getTypeStage() %>
                            </span>
                        </div>
                        
                        <div class="offer-entreprise">
                            <strong> <%= offre.getEntrepriseName() %></strong>
                        </div>
                        
                        <div class="offer-details">
                            <div class="detail-item">
                                <span><%= offre.getSpecialite() %></span>
                            </div>
                            <div class="detail-item">
                                <span><%= offre.getZoneGeographique() %></span>
                            </div>
                            <div class="detail-item">
                                <span><%= offre.getDureeMois() %> mois</span>
                            </div>
                            <% if (offre.getRemuneration() != null && !offre.getRemuneration().isEmpty()) { %>
                                <div class="detail-item">
                                    <span><%= offre.getRemuneration() %></span>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="offer-description">
                            <p><%= offre.getDescription().length() > 150 ? 
                                    offre.getDescription().substring(0, 150) + "..." : 
                                    offre.getDescription() %></p>
                        </div>
                        
                        <% if (offre.getCompetencesRequises() != null && !offre.getCompetencesRequises().isEmpty()) { %>
                            <div class="offer-skills">
                                <strong>Compétences :</strong> <%= offre.getCompetencesRequises() %>
                            </div>
                        <% } %>
                        
                        <div class="offer-actions">
                            <a href="candidature?action=apply&offreId=<%= offre.getId() %>" class="btn btn-primary">
                                Postuler
                            </a>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-results">
                    <p>Aucune offre de stage ne correspond à vos critères.</p>
                    <a href="offres" class="btn btn-primary">Voir toutes les offres</a>
                </div>
            <% } %>
        </div>
    </div>
    
    <script src="js/main.js"></script>
</body>
</html>
