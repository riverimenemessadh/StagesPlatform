<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - StageConnect</title>
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
            <h1>Mon Profil</h1>
            <p>Completez votre profil pour acceder aux offres de stage</p>
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
                    <h3><%= user.getFullName() %></h3>
                    <p class="text-muted"><%= user.getEmail() %></p>
                </div>
                
                <hr class="mb-xl">
                
                <form action="profile" method="post" class="profile-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="specialite">Spécialité  <span class="required"></span></label>
                            <select id="specialite" name="specialite" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="Développement Web et Mobile" 
                                    <%= "Développement Web et Mobile".equals(user.getSpecialite()) ? "selected" : "" %>>
                                    Développement Web et Mobile
                                </option>
                                <option value="Développement Web" 
                                    <%= "Développement Web".equals(user.getSpecialite()) ? "selected" : "" %>>
                                    Développement Web
                                </option>
                                <option value="Développement Mobile" 
                                    <%= "Développement Mobile".equals(user.getSpecialite()) ? "selected" : "" %>>
                                    Développement Mobile
                                </option>
                                <option value="Data Science" 
                                    <%= "Data Science".equals(user.getSpecialite()) ? "selected" : "" %>>
                                    Data Science
                                </option>
                                <option value="Cyber Sécurité" 
                                    <%= "Cyber Sécurité".equals(user.getSpecialite()) ? "selected" : "" %>>
                                    Cyber Sécurité
                                </option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="typeStage">Type de stage <span class="required"></span></label>
                            <select id="typeStage" name="typeStage" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="Présentiel" 
                                    <%= "Présentiel".equals(user.getTypeStage()) ? "selected" : "" %>>
                                    Présentiel
                                </option>
                                <option value="Apprentissage" 
                                    <%= "Apprentissage".equals(user.getTypeStage()) ? "selected" : "" %>>
                                    Apprentissage
                                </option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="zone">Zone géographique </label>
                            <select id="zone" name="zone" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="Alger" 
                                    <%= "Alger".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Alger
                                </option>
                                <option value="Oran" 
                                    <%= "Oran".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Oran
                                </option>
                                <option value="Constantine" 
                                    <%= "Constantine".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Constantine
                                </option>
                                <option value="Annaba" 
                                    <%= "Annaba".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Annaba
                                </option>
                                <option value="Blida" 
                                    <%= "Blida".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Blida
                                </option>
                                <option value="Sétif" 
                                    <%= "Sétif".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Sétif
                                </option>
                                <option value="Tipaza" 
                                    <%= "Tipaza".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Tipaza
                                </option>
                                <option value="Béjaïa" 
                                    <%= "Béjaïa".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Béjaïa
                                </option>
                                <option value="Batna" 
                                    <%= "Batna".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Batna
                                </option>
                                <option value="Tlemcen" 
                                    <%= "Tlemcen".equals(user.getZoneGeographique()) ? "selected" : "" %>>
                                    Tlemcen
                                </option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="telephone">Téléphone</label>
                            <input type="tel" id="telephone" name="telephone"
                                   placeholder="0550 12 34 56"
                                   pattern="0[5-7][0-9]{8}"
                                   title="Format: 0XXXXXXXXX (10 chiffres, commence par 05, 06 ou 07)"
                                   value="<%= user.getTelephone() != null ? user.getTelephone() : "" %>">
                            <small class="form-text">Format algérien: 10 chiffres commençant par 05, 06 ou 07</small>
                        </div>
                    </div>
                    
                    <div id="noChangesError" class="error-message" style="display: none; margin-bottom: var(--spacing-lg); padding: var(--spacing-md); background-color: var(--color-warning-bg); border-left: 3px solid var(--color-warning); border-radius: var(--radius-sm); color: #856404; font-weight: var(--font-weight-medium);">
                        <strong>Attention :</strong> Aucune modification détectée. Veuillez modifier au moins un champ avant de soumettre.
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            Enregistrer le profil
                        </button>
                        <% if (user.isProfileCompleted()) { %>
                            <a href="offres" class="btn btn-secondary">Voir les offres</a>
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