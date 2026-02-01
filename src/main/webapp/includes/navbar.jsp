<%@ page import="com.stages.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    if (navUser == null) {
        return;
    }
%>
<nav class="navbar">
    <div class="nav-container">
        <div class="nav-brand">
            <a href="offres">
                <span>StageConnect</span>
                <span class="nav-subtitle">Construisez votre parcours de stage</span>
            </a>
        </div>
        
        <button class="nav-toggle" onclick="toggleMobileMenu()">
            Menu
        </button>
        
        <ul class="nav-menu" id="navMenu">
            <li><a href="offres">Offres de stage</a></li>
            <li><a href="candidature">Mes Candidatures</a></li>
            <li><a href="entreprises">Entreprises</a></li>
            <li><a href="profile">Profil</a></li>
            <li class="nav-user">
                <span class="user-name"><%= navUser.getFullName() %></span>
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
