<%@ page import="com.stages.model.Entreprise" %>
<%
    Entreprise navEntreprise = (Entreprise) session.getAttribute("entreprise");
    if (navEntreprise == null) {
        return;
    }
%>
<nav class="navbar navbar-entreprise">
    <div class="nav-container">
        <div class="nav-brand">
            <a href="entreprise-dashboard">
                <span>StageConnect</span>
                <span class="nav-subtitle">Accueillez et encadrez des stagiaires</span>
            </a>
        </div>
        
        <button class="nav-toggle" onclick="toggleMobileMenu()">
            Menu
        </button>
        
        <ul class="nav-menu" id="navMenu">
            <li><a href="entreprise-dashboard">Gerer les candidatures</a></li>
            <li><a href="entreprise-stagiaires">Suivi des stagiaires</a></li>
            <li><a href="entreprise-offres">Mes offres de stage</a></li>
            <li><a href="entreprise-profile">Profil</a></li>
            <li class="nav-user">
                <span class="user-name"><%= navEntreprise.getNom() %></span>
            </li>
            <li><a href="logout" class="btn-logout">Se deconnecter</a></li>
        </ul>
    </div>
</nav>

<script>
    function toggleMobileMenu() {
        const menu = document.getElementById('navMenu');
        menu.classList.toggle('active');
    }
</script>
