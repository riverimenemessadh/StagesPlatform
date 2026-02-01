<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - StageConnect</title>
    
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
                <h1>StageConnect</h1>
                <p>Connectez-vous a votre compte</p>
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
            
            <div class="tab-buttons">
                <button class="tab-btn active" onclick="switchTab('student')">Apprenant</button>
                <button class="tab-btn" onclick="switchTab('entreprise')">Entreprise</button>
                <button class="tab-btn" onclick="switchTab('admin')">Administration de l'Institut</button>
            </div>
            
            <form action="login" method="post" class="auth-form">
                <input type="hidden" name="userType" id="userType" value="student">
                
                <div class="form-group">
                    <label for="email">Email / Nom d'utilisateur</label>
                    <input type="text" id="email" name="email" required 
                           placeholder="votre.email@exemple.com">
                </div>
                
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required
                           placeholder="Entrez votre mot de passe">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    Se connecter
                </button>
            </form>
            
            <div class="auth-footer" id="studentFooter">
                <p>Pas encore de compte ? <a href="register?type=student">S'inscrire</a></p>
            </div>
            
            <div class="auth-footer" id="entrepriseFooter" style="display: none;">
                <p>Pas encore de compte ? <a href="register?type=entreprise">S'inscrire</a></p>
            </div>
            
            <div class="auth-footer" id="adminFooter" style="display: none;">
                <p class="text-muted">Acces reserve aux administrateurs</p>
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
        function switchTab(type) {
            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            document.getElementById('userType').value = type;
            
            // Hide all footers
            document.getElementById('studentFooter').style.display = 'none';
            document.getElementById('entrepriseFooter').style.display = 'none';
            document.getElementById('adminFooter').style.display = 'none';
            
            if (type === 'admin') {
                document.getElementById('adminFooter').style.display = 'block';
                document.getElementById('email').placeholder = "Nom d'utilisateur";
            } else if (type === 'entreprise') {
                document.getElementById('entrepriseFooter').style.display = 'block';
                document.getElementById('email').placeholder = "email@entreprise.com";
            } else {
                document.getElementById('studentFooter').style.display = 'block';
                document.getElementById('email').placeholder = "votre.email@exemple.com";
            }
        }
    </script>
</body>
</html>
