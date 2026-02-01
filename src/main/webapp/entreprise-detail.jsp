<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*" %>
<%
    Entreprise entreprise = (Entreprise) request.getAttribute("entreprise");
    List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= entreprise.getNom() %> - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <% if (session.getAttribute("user") != null) { %>
        <jsp:include page="includes/navbar.jsp" />
    <% } else { %>
        <jsp:include page="includes/navbar-admin.jsp" />
    <% } %>
    
    <div class="container">
        <div class="page-header">
            <a href="entreprises" class="back-link">← Retour aux entreprises</a>
            <h1><%= entreprise.getNom() %></h1>
        </div>
        
        <div class="card">
            <div class="card-body">
                <% if (entreprise.getDescription() != null && !entreprise.getDescription().isEmpty()) { %>
                    <p class="entreprise-description mb-lg"><%= entreprise.getDescription() %></p>
                <% } %>
                
                <div class="entreprise-info-grid">
                    <% if (entreprise.getAdresse() != null && !entreprise.getAdresse().isEmpty()) { %>
                        <div class="info-item">
                            <strong> Adresse :</strong> <%= entreprise.getAdresse() %>
                        </div>
                    <% } %>
                    <% if (entreprise.getZoneGeographique() != null && !entreprise.getZoneGeographique().isEmpty()) { %>
                        <div class="info-item">
                            <strong> Zone :</strong> <%= entreprise.getZoneGeographique() %>
                        </div>
                    <% } %>
                    <% if (entreprise.getSecteur() != null && !entreprise.getSecteur().isEmpty()) { %>
                        <div class="info-item">
                            <strong> Secteur :</strong> <%= entreprise.getSecteur() %>
                        </div>
                    <% } %>
                    <% if (entreprise.getEmail() != null && !entreprise.getEmail().isEmpty()) { %>
                        <div class="info-item">
                            <strong> Email :</strong> <%= entreprise.getEmail() %>
                        </div>
                    <% } %>
                    <% if (entreprise.getTelephone() != null && !entreprise.getTelephone().isEmpty()) { %>
                        <div class="info-item">
                            <strong> Téléphone :</strong> <%= entreprise.getTelephone() %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <h2 class="mt-xl mb-lg">Offres de stage disponibles</h2>
        
        <% if (offres != null && !offres.isEmpty()) { %>
            <div class="offers-grid">
                <% for (OffreStage offre : offres) { %>
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3><%= offre.getTitre() %></h3>
                            <span class="badge badge-<%= offre.getTypeStage().equals("Apprentissage") ? "primary" : "secondary" %>">
                                <%= offre.getTypeStage() %>
                            </span>
                        </div>
                        
                        <div class="offer-details">
                            <div class="detail-item">
                                <span class="icon"></span>
                                <span><%= offre.getSpecialite() %></span>
                            </div>
                            <div class="detail-item">
                                <span class="icon"></span>
                                <span><%= offre.getDureeMois() %> mois</span>
                            </div>
                            <div class="detail-item">
                                <span class="icon"></span>
                                <span><%= offre.getZoneGeographique() %></span>
                            </div>
                            <% if (offre.getRemuneration() != null && !offre.getRemuneration().isEmpty()) { %>
                                <div class="detail-item">
                                    <span class="icon"></span>
                                    <span><%= offre.getRemuneration() %></span>
                                </div>
                            <% } %>
                        </div>
                        
                        <p class="text-secondary"><%= offre.getDescription() %></p>
                        
                        <% if (offre.getCompetencesRequises() != null && !offre.getCompetencesRequises().isEmpty()) { %>
                            <div class="mt-md">
                                <strong>Compétences requises :</strong>
                                <p class="text-muted"><%= offre.getCompetencesRequises() %></p>
                            </div>
                        <% } %>
                        
                        <% if (session.getAttribute("user") != null) { %>
                            <div class="offer-actions-footer">
                                <a href="candidature?action=apply&offreId=<%= offre.getId() %>" class="btn btn-primary">
                                     Postuler
                                </a>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <p class="text-muted text-center" style="padding: var(--spacing-3xl);">
                Aucune offre disponible actuellement pour cette entreprise.
            </p>
        <% } %>
    </div>
</body>
</html>
