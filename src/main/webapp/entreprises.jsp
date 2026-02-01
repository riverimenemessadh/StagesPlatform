<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*" %>
<%
    Object userObj = session.getAttribute("user");
    Object adminObj = session.getAttribute("admin");
    
    if (userObj == null && adminObj == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<Entreprise> entreprises = (List<Entreprise>) request.getAttribute("entreprises");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entreprises - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <% if (userObj != null) { %>
        <jsp:include page="includes/navbar.jsp" />
    <% } else { %>
        <jsp:include page="includes/navbar-admin.jsp" />
    <% } %>
    
    <div class="container">
        <div class="page-header">
            <h1>Entreprises</h1>
            <p>Decouvrez nos entreprises partenaires</p>
        </div>
        
        <% if (entreprises != null && !entreprises.isEmpty()) { %>
            <div class="companies-grid">
                <% for (Entreprise entreprise : entreprises) { %>
                    <div class="entreprise-card">
                        <div class="entreprise-header">
                            <h3><%= entreprise.getNom() %></h3>
                            <% if (entreprise.getSecteur() != null) { %>
                                <span class="badge badge-secondary"><%= entreprise.getSecteur() %></span>
                            <% } %>
                        </div>
                        
                        <div class="entreprise-details">
                            <% if (entreprise.getDescription() != null && !entreprise.getDescription().isEmpty()) { %>
                                <p class="entreprise-description"><%= entreprise.getDescription() %></p>
                            <% } %>
                            
                            <% if (entreprise.getAdresse() != null && !entreprise.getAdresse().isEmpty()) { %>
                                <div class="detail-item">
                                    <span class="icon"></span>
                                    <span><%= entreprise.getAdresse() %></span>
                                </div>
                            <% } %>
                            
                            <% if (entreprise.getZoneGeographique() != null && !entreprise.getZoneGeographique().isEmpty()) { %>
                                <div class="detail-item">
                                    <span class="icon"></span>
                                    <span><%= entreprise.getZoneGeographique() %></span>
                                </div>
                            <% } %>
                            
                            <% if (entreprise.getEmail() != null && !entreprise.getEmail().isEmpty()) { %>
                                <div class="detail-item">
                                    <span class="icon"></span>
                                    <span><%= entreprise.getEmail() %></span>
                                </div>
                            <% } %>
                            
                            <% if (entreprise.getTelephone() != null && !entreprise.getTelephone().isEmpty()) { %>
                                <div class="detail-item">
                                    <span class="icon"></span>
                                    <span><%= entreprise.getTelephone() %></span>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="entreprise-actions">
                            <a href="entreprises?id=<%= entreprise.getId() %>" class="btn btn-primary">
                                Voir les offres
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <p class="text-center text-muted">Aucune entreprise partenaire pour le moment.</p>
        <% } %>
    </div>
</body>
</html>
