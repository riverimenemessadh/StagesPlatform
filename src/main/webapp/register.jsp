<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userType = request.getParameter("type");
    if (userType == null || userType.isEmpty()) {
        userType = "student";
    }
    boolean isEntreprise = "entreprise".equals(userType);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - StageConnect</title>
    
    <!-- Favicons -->
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="192x192" href="<%= request.getContextPath() %>/android-chrome-192x192.png">
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="auth-layout">
        <!-- Left Side: Form -->
        <div class="auth-form-side">
            <div class="auth-container">
                <!-- Logo for Mobile Only -->
                <div class="auth-logo-mobile">
                    <img src="<%= request.getContextPath() %>/images/logo-mobile.png" alt="StageConnect Logo">
                </div>
                
                <div class="auth-card">
            <div class="auth-header">
                <h1>Creer un compte</h1>
                <p>Inscrivez-vous pour acceder aux offres de stage</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <div class="tab-buttons">
                <button class="tab-btn <%= !isEntreprise ? "active" : "" %>" onclick="switchRegisterTab('student')">Étudiant</button>
                <button class="tab-btn <%= isEntreprise ? "active" : "" %>" onclick="switchRegisterTab('entreprise')">Entreprise</button>
            </div>
            
            <!-- Student Registration Form -->
            <form action="register" method="post" class="auth-form" id="studentForm" style="<%= isEntreprise ? "display: none;" : "" %>">
                <input type="hidden" name="userType" value="student">
                
                <div class="form-group">
                    <label for="onefdId">Identifiant ONEFD *</label>
                    <input type="text" id="onefdId" name="onefdId" required
                           pattern="\d{4}/\d{3}/\d{4}"
                           placeholder="YYYY/XXX/XXXX (ex: 2024/123/4567)"
                           title="Format: YYYY/XXX/XXXX"
                           value="<%= request.getParameter("onefdId") != null ? request.getParameter("onefdId") : "" %>">
                    <small class="form-text">Utilisez l'identifiant fourni par ONEFD</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="nom">Nom *</label>
                        <input type="text" id="nom" name="nom" required
                               value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="prenom">Prénom *</label>
                        <input type="text" id="prenom" name="prenom" required
                               value="<%= request.getParameter("prenom") != null ? request.getParameter("prenom") : "" %>">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mot de passe *</label>
                    <input type="password" id="password" name="password" required
                           placeholder="Minimum 6 caractères" minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirmer le mot de passe *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required
                           placeholder="Confirmez votre mot de passe">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    S'inscrire
                </button>
            </form>
            
            <!-- Enterprise Registration Form -->
            <form action="register" method="post" class="auth-form" id="entrepriseForm" style="<%= !isEntreprise ? "display: none;" : "" %>">
                <input type="hidden" name="userType" value="entreprise">
                
                <div class="form-group">
                    <label for="nomEntreprise">Nom de l'entreprise *</label>
                    <input type="text" id="nomEntreprise" name="nomEntreprise" required
                           value="<%= request.getParameter("nomEntreprise") != null ? request.getParameter("nomEntreprise") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="emailEntreprise">Email *</label>
                    <input type="email" id="emailEntreprise" name="email" required
                           placeholder="contact@entreprise.com"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="passwordEntreprise">Mot de passe *</label>
                    <input type="password" id="passwordEntreprise" name="password" required
                           placeholder="Minimum 6 caractères" minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmPasswordEntreprise">Confirmer le mot de passe *</label>
                    <input type="password" id="confirmPasswordEntreprise" name="confirmPassword" required
                           placeholder="Confirmez votre mot de passe">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    S'inscrire
                </button>
            </form>
            
            <div class="auth-footer">
                <p>Déjà un compte ? <a href="login">Se connecter</a></p>
            </div>
        </div>
            </div>
        </div>
        
        <!-- Right Side: Branding Image -->
        <div class="auth-image-side">
            <img src="<%= request.getContextPath() %>/images/auth-side.png" alt="StageConnect" class="auth-side-image">
        </div>
    </div>
    
    <script>
        function switchRegisterTab(type) {
            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            const studentForm = document.getElementById('studentForm');
            const entrepriseForm = document.getElementById('entrepriseForm');
            
            if (type === 'entreprise') {
                studentForm.style.display = 'none';
                entrepriseForm.style.display = 'block';
            } else {
                studentForm.style.display = 'block';
                entrepriseForm.style.display = 'none';
            }
        }
    </script>
</body>
</html>