<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.Entreprise" %>
<%
    Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
    if (entreprise == null) {
        response.sendRedirect("login");
        return;
    }
    
    String[] selectedSpecialites = new String[0];
    if (entreprise.getSpecialites() != null && !entreprise.getSpecialites().isEmpty()) {
        selectedSpecialites = entreprise.getSpecialites().split(",");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Entreprise - StageConnect</title>
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
            <h1>Profil de l'Entreprise</h1>
            <p>Completez votre profil pour publier des offres de stage</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <div class="card">
            <div class="card-body">
                <div class="profile-info mb-xl">
                    <h3><%= entreprise.getNom() %></h3>
                    <p class="text-muted"><%= entreprise.getEmail() %></p>
                </div>
                
                <hr class="mb-xl">
                
                <form action="entreprise-profile" method="post" class="profile-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="secteur">Secteur d'activité <span class="required"></span></label>
                            <select id="secteur" name="secteur" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="Télécommunications" 
                                    <%= "Télécommunications".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Télécommunications
                                </option>
                                <option value="Énergie" 
                                    <%= "Énergie".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Énergie
                                </option>
                                <option value="Technologies de l'information" 
                                    <%= "Technologies de l'information".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Technologies de l'information
                                </option>
                                <option value="Services Postaux" 
                                    <%= "Services Postaux".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Services Postaux
                                </option>
                                <option value="Transport" 
                                    <%= "Transport".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Transport
                                </option>
                                <option value="Services Publics" 
                                    <%= "Services Publics".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Services Publics
                                </option>
                                <option value="Industrie" 
                                    <%= "Industrie".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Industrie
                                </option>
                                <option value="Finance" 
                                    <%= "Finance".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Finance
                                </option>
                                <option value="E-commerce" 
                                    <%= "E-commerce".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    E-commerce
                                </option>
                                <option value="Autre" 
                                    <%= "Autre".equals(entreprise.getSecteur()) ? "selected" : "" %>>
                                    Autre
                                </option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="zone">Zone géographique </label>
                            <select id="zone" name="zone" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="Alger" 
                                    <%= "Alger".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Alger
                                </option>
                                <option value="Oran" 
                                    <%= "Oran".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Oran
                                </option>
                                <option value="Constantine" 
                                    <%= "Constantine".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Constantine
                                </option>
                                <option value="Annaba" 
                                    <%= "Annaba".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Annaba
                                </option>
                                <option value="Blida" 
                                    <%= "Blida".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Blida
                                </option>
                                <option value="Sétif" 
                                    <%= "Sétif".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Sétif
                                </option>
                                <option value="Tipaza" 
                                    <%= "Tipaza".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Tipaza
                                </option>
                                <option value="Béjaïa" 
                                    <%= "Béjaïa".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Béjaïa
                                </option>
                                <option value="Batna" 
                                    <%= "Batna".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Batna
                                </option>
                                <option value="Tlemcen" 
                                    <%= "Tlemcen".equals(entreprise.getZoneGeographique()) ? "selected" : "" %>>
                                    Tlemcen
                                </option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="adresse">Adresse</label>
                        <input type="text" id="adresse" name="adresse"
                               placeholder="15 Rue Didouche Mourad, Alger"
                               value="<%= entreprise.getAdresse() != null ? entreprise.getAdresse() : "" %>">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="telephone">Téléphone</label>
                            <input type="tel" id="telephone" name="telephone"
                                   placeholder="021 12 34 56"
                                   pattern="0[1-9][0-9]{8}"
                                   title="Format: 0XXXXXXXXX (10 chiffres)"
                                   value="<%= entreprise.getTelephone() != null ? entreprise.getTelephone() : "" %>">
                            <small class="form-text">Format algérien: 10 chiffres commençant par 0</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="siteWeb">Site web</label>
                            <input type="url" id="siteWeb" name="siteWeb"
                                   placeholder="https://www.entreprise.com"
                                   value="<%= entreprise.getSiteWeb() != null ? entreprise.getSiteWeb() : "" %>">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description de l'entreprise</label>
                        <textarea id="description" name="description" rows="4"
                                  placeholder="Présentez votre entreprise et ses activités..."><%= entreprise.getDescription() != null ? entreprise.getDescription() : "" %></textarea>
                    </div>
                    
                    <div id="noChangesError" class="error-message" style="display: none; margin-bottom: var(--spacing-lg); padding: var(--spacing-md); background-color: var(--color-warning-bg); border-left: 3px solid var(--color-warning); border-radius: var(--radius-sm); color: #856404; font-weight: var(--font-weight-medium);">
                        <strong>Attention :</strong> Aucune modification détectée. Veuillez modifier au moins un champ avant de soumettre.
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            Enregistrer le profil
                        </button>
                        <% if (entreprise.isProfileCompleted()) { %>
                            <a href="entreprise-dashboard" class="btn btn-secondary">Tableau de bord</a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Prevent form submission if no changes made
        (function() {
            const form = document.querySelector('.profile-form');
            const errorDiv = document.getElementById('noChangesError');
            const initialData = new FormData(form);
            const initialValues = {};
            
            // Store initial values
            for (let [key, value] of initialData.entries()) {
                initialValues[key] = value;
            }
            
            form.addEventListener('submit', function(e) {
                const currentData = new FormData(form);
                let hasChanges = false;
                
                // Check if any field has changed
                for (let [key, value] of currentData.entries()) {
                    if (initialValues[key] !== value) {
                        hasChanges = true;
                        break;
                    }
                }
                
                if (!hasChanges) {
                    e.preventDefault();
                    errorDiv.style.display = 'block';
                    errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return false;
                }
                errorDiv.style.display = 'none';
            });
            
            // Hide error message when user starts making changes
            form.addEventListener('input', function() {
                if (errorDiv.style.display === 'block') {
                    errorDiv.style.display = 'none';
                }
            });
        })();
    </script>
</body>
</html>
