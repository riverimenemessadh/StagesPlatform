<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur 500 - Erreur serveur</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
        }
        
        .error-card {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 60px 40px;
            text-align: center;
        }
        
        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: var(--color-danger, #dc2626);
            line-height: 1;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-size: 28px;
            font-weight: 600;
            color: var(--color-text-main, #1f2937);
            margin-bottom: 15px;
        }
        
        .error-message {
            font-size: 16px;
            color: var(--color-text-muted, #6b7280);
            line-height: 1.6;
            margin-bottom: 40px;
        }
        
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .error-btn {
            padding: 12px 30px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
        }
        
        .error-btn-primary {
            background: var(--color-primary, #2563eb);
            color: white;
        }
        
        .error-btn-primary:hover {
            background: var(--color-primary-hover, #1d4ed8);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        
        .error-btn-secondary {
            background: var(--color-bg-surface, #f3f4f6);
            color: var(--color-text-main, #1f2937);
        }
        
        .error-btn-secondary:hover {
            background: var(--color-bg-elevated, #e5e7eb);
        }
        
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.8;
        }
        
        .error-details {
            margin-top: 30px;
            padding: 20px;
            background: var(--color-bg-surface, #f9fafb);
            border-radius: 8px;
            text-align: left;
            font-size: 14px;
            color: var(--color-text-muted, #6b7280);
            max-height: 200px;
            overflow-y: auto;
        }
        
        .error-details code {
            display: block;
            white-space: pre-wrap;
            word-break: break-all;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">⚠️</div>
            <div class="error-code">500</div>
            <h1 class="error-title">Erreur serveur interne</h1>
            <p class="error-message">
                Une erreur inattendue s'est produite sur le serveur.
                Nos équipes ont été informées et travaillent pour résoudre ce problème.
                Veuillez réessayer dans quelques instants.
            </p>
            <div class="error-actions">
                <a href="javascript:history.back()" class="error-btn error-btn-secondary">
                    ← Retour
                </a>
                <a href="<%= request.getContextPath() %>/login" class="error-btn error-btn-primary">
                    🏠 Accueil
                </a>
            </div>
            
            <% if (exception != null && request.getParameter("debug") != null) { %>
                <div class="error-details">
                    <strong>Détails de l'erreur (mode debug):</strong><br>
                    <code><%= exception.getMessage() != null ? exception.getMessage() : "Aucun message d'erreur" %></code>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
