<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<User> students = (List<User>) request.getAttribute("students");
    List<Entreprise> entreprises = (List<Entreprise>) request.getAttribute("entreprises");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerer les Utilisateurs - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/apple-touch-icon.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="includes/navbar-admin.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>Gerer les Utilisateurs</h1>
            <p>Voir et gerer les apprenants et entreprises</p>
        </div>
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- Students Section -->
        <div class="card mb-xl">
            <div class="card-header">
                <h2>Apprenants (<%= students != null ? students.size() : 0 %>)</h2>
            </div>
            <div class="card-body">
                
                <% if (students != null && !students.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Email</th>
                                    <th>Spécialité</th>
                                    <th>Zone</th>
                                    <th>Profil Complet</th>
                                    <th>Inscrit le</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User student : students) { %>
                                    <tr>
                                        <td><%= student.getFullName() %></td>
                                        <td><%= student.getEmail() %></td>
                                        <td><%= student.getSpecialite() != null ? student.getSpecialite() : "-" %></td>
                                        <td><%= student.getZoneGeographique() != null ? student.getZoneGeographique() : "-" %></td>
                                        <td>
                                            <% if (student.isProfileCompleted()) { %>
                                                <span class="badge badge-success">Oui</span>
                                            <% } else { %>
                                                <span class="badge badge-warning">Non</span>
                                            <% } %>
                                        </td>
                                        <td><%= student.getCreatedAt() != null ? sdf.format(student.getCreatedAt()) : "-" %></td>
                                        <td class="actions-cell">
                                            <button onclick="viewUserDetails('student', <%= student.getId() %>)" class="btn btn-sm btn-secondary">
                                                Details
                                            </button>
                                            <button onclick="confirmDelete('student', <%= student.getId() %>, '<%= student.getFullName() %>')" 
                                                    class="btn btn-sm btn-danger">
                                                Supprimer
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Hidden details row -->
                                    <tr id="student-details-<%= student.getId() %>" class="details-row">
                                        <td colspan="7">
                                            <div class="user-details">
                                                <h4>Détails de l'Apprenant</h4>
                                                <div class="entreprise-info-grid">
                                                    <div><strong>Nom complet:</strong> <%= student.getFullName() %></div>
                                                    <div><strong>Email:</strong> <%= student.getEmail() %></div>
                                                    <% if (student.getTelephone() != null) { %>
                                                        <div><strong>Téléphone:</strong> <%= student.getTelephone() %></div>
                                                    <% } %>
                                                    <% if (student.getSpecialite() != null) { %>
                                                        <div><strong>Spécialité:</strong> <%= student.getSpecialite() %></div>
                                                    <% } %>
                                                    <% if (student.getTypeStage() != null) { %>
                                                        <div><strong>Type de stage:</strong> <%= student.getTypeStage() %></div>
                                                    <% } %>
                                                    <% if (student.getZoneGeographique() != null) { %>
                                                        <div><strong>Zone:</strong> <%= student.getZoneGeographique() %></div>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">Aucun Apprenant inscrit.</p>
                <% } %>
            </div>
        </div>
        
        <!-- Enterprises Section -->
        <div class="card">
            <div class="card-header">
                <h2>Entreprises (<%= entreprises != null ? entreprises.size() : 0 %>)</h2>
            </div>
            <div class="card-body">
                
                <% if (entreprises != null && !entreprises.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Email</th>
                                    <th>Secteur</th>
                                    <th>Zone</th>
                                    <th>Profil Complet</th>
                                    <th>Inscrit le</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Entreprise ent : entreprises) { %>
                                    <tr>
                                        <td><%= ent.getNom() %></td>
                                        <td><%= ent.getEmail() %></td>
                                        <td><%= ent.getSecteur() != null ? ent.getSecteur() : "-" %></td>
                                        <td><%= ent.getZoneGeographique() != null ? ent.getZoneGeographique() : "-" %></td>
                                        <td>
                                            <% if (ent.isProfileCompleted()) { %>
                                                <span class="badge badge-success">Oui</span>
                                            <% } else { %>
                                                <span class="badge badge-warning">Non</span>
                                            <% } %>
                                        </td>
                                        <td><%= ent.getCreatedAt() != null ? sdf.format(ent.getCreatedAt()) : "-" %></td>
                                        <td class="actions-cell">
                                            <button onclick="viewUserDetails('entreprise', <%= ent.getId() %>)" class="btn btn-sm btn-secondary">
                                                Details
                                            </button>
                                            <button onclick="confirmDelete('entreprise', <%= ent.getId() %>, '<%= ent.getNom() %>')" 
                                                    class="btn btn-sm btn-danger">
                                                Supprimer
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <!-- Hidden details row -->
                                    <tr id="entreprise-details-<%= ent.getId() %>" class="details-row">
                                        <td colspan="7">
                                            <div class="user-details">
                                                <h4>Détails de l'entreprise</h4>
                                                <div class="entreprise-info-grid">
                                                    <div><strong>Nom:</strong> <%= ent.getNom() %></div>
                                                    <div><strong>Email:</strong> <%= ent.getEmail() %></div>
                                                    <% if (ent.getTelephone() != null) { %>
                                                        <div><strong>Téléphone:</strong> <%= ent.getTelephone() %></div>
                                                    <% } %>
                                                    <% if (ent.getSecteur() != null) { %>
                                                        <div><strong>Secteur:</strong> <%= ent.getSecteur() %></div>
                                                    <% } %>
                                                    <% if (ent.getZoneGeographique() != null) { %>
                                                        <div><strong>Zone:</strong> <%= ent.getZoneGeographique() %></div>
                                                    <% } %>
                                                    <% if (ent.getAdresse() != null) { %>
                                                        <div><strong>Adresse:</strong> <%= ent.getAdresse() %></div>
                                                    <% } %>
                                                    <% if (ent.getSiteWeb() != null) { %>
                                                        <div><strong>Site web:</strong> <a href="<%= ent.getSiteWeb() %>" target="_blank"><%= ent.getSiteWeb() %></a></div>
                                                    <% } %>
                                                    <% if (ent.getSpecialites() != null) { %>
                                                        <div><strong>Spécialités:</strong> <%= ent.getSpecialites() %></div>
                                                    <% } %>
                                                </div>
                                                <% if (ent.getDescription() != null && !ent.getDescription().isEmpty()) { %>
                                                    <div class="mt-md">
                                                        <strong>Description:</strong>
                                                        <p><%= ent.getDescription() %></p>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">Aucune entreprise inscrite.</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2>Confirmer la suppression</h2>
            <p id="deleteMessage"></p>
            <form action="admin-users" method="post">
                <input type="hidden" id="deleteUserType" name="userType">
                <input type="hidden" id="deleteUserId" name="userId">
                <input type="hidden" name="action" value="delete">
                
                <div class="modal-actions">
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                    <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function viewUserDetails(type, id) {
            const row = document.getElementById(type + '-details-' + id);
            if (row.style.display === 'none') {
                row.style.display = 'table-row';
            } else {
                row.style.display = 'none';
            }
        }
        
        function confirmDelete(type, id, name) {
            document.getElementById('deleteUserType').value = type;
            document.getElementById('deleteUserId').value = id;
            
            const typeName = type === 'student' ? 'l\'Apprenant' : 'l\'entreprise';
            document.getElementById('deleteMessage').textContent = 
                'Êtes-vous sûr de vouloir supprimer ' + typeName + ' "' + name + '" ? Cette action est irréversible.';
            
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target === modal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>
