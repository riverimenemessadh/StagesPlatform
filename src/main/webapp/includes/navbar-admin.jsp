<%
    String navAdmin = (String) session.getAttribute("admin");
    if (navAdmin == null) {
        return;
    }
%>
<nav class="navbar navbar-admin">
    <div class="nav-container">
        <div class="nav-brand">
            <a href="admin">
                <span>StageConnect</span>
                <span class="nav-subtitle">Pilotez la gestion des stages</span>
            </a>
        </div>
        
        <button class="nav-toggle" onclick="toggleMobileMenu()">
            Menu
        </button>
        
        <ul class="nav-menu" id="navMenu">
            <li><a href="admin">Tableau de bord</a></li>
            <li><a href="admin-candidatures">Candidatures</a></li>
            <li><a href="admin-offres">Offres Entreprises</a></li>
            <li><a href="admin-users">Gerer les utilisateurs</a></li>
            <li class="nav-user">
                <span class="user-name"><%= navAdmin %></span>
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
