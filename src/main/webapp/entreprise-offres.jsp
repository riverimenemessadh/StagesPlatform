<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
    if (entreprise == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Offres - StageConnect</title>
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
            <h1>Mes Offres de Stage</h1>
            <p>Gerez vos offres de stage</p>
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
        
        <div class="mb-lg">
            <button onclick="openOfferModal()" class="btn btn-primary">
                Creer une nouvelle offre
            </button>
        </div>
        
        <div class="card">
            <div class="card-body">
                <% if (offres != null && !offres.isEmpty()) { %>
                    <div class="offers-list">
                        <% for (OffreStage offre : offres) { %>
                            <div class="offer-card mb-lg">
                                <div class="offer-header">
                                    <h3><%= offre.getTitre() %></h3>
                                    <div class="offer-actions">
                                        <button onclick="openEditModal(<%= offre.getId() %>, '<%= offre.getTitre().replace("'", "\\'") %>', '<%= offre.getDescription() != null ? offre.getDescription().replace("'", "\\'").replace("\n", " ").replace("\r", "") : "" %>', '<%= offre.getSpecialite() %>', '<%= offre.getTypeStage() %>', '<%= offre.getZoneGeographique() %>', <%= offre.getDureeMois() %>, '<%= offre.getRemuneration() != null ? offre.getRemuneration() : "" %>', '<%= offre.getCompetencesRequises() != null ? offre.getCompetencesRequises().replace("'", "\\'").replace("\n", " ").replace("\r", "") : "" %>')" 
                                                class="btn btn-sm btn-secondary">
                                            Modifier
                                        </button>
                                        <button onclick="confirmDelete(<%= offre.getId() %>, '<%= offre.getTitre().replace("'", "\\'") %>')" 
                                                class="btn btn-sm btn-danger">
                                            Supprimer
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="entreprise-info-grid">
                                    <div>
                                        <strong>Spécialité:</strong> <%= offre.getSpecialite() %>
                                    </div>
                                    <div>
                                        <strong>Type:</strong> <%= offre.getTypeStage() %>
                                    </div>
                                    <div>
                                        <strong>Zone:</strong> <%= offre.getZoneGeographique() %>
                                    </div>
                                    <div>
                                        <strong>Durée:</strong> <%= offre.getDureeMois() %> mois
                                    </div>
                                    <% if (offre.getCreatedAt() != null) { %>
                                        <div>
                                            <strong>Créé le:</strong> <%= sdf.format(offre.getCreatedAt()) %>
                                        </div>
                                    <% } %>
                                    <% if (offre.getRemuneration() != null) { %>
                                        <div>
                                            <strong>Rémunération:</strong> <%= offre.getRemuneration() %>
                                        </div>
                                    <% } %>
                                </div>
                                
                                <% if (offre.getDescription() != null && !offre.getDescription().isEmpty()) { %>
                                    <div class="mb-md">
                                        <strong>Description:</strong>
                                        <p class="text-secondary"><%= offre.getDescription() %></p>
                                    </div>
                                <% } %>
                                
                                <% if (offre.getCompetencesRequises() != null && !offre.getCompetencesRequises().isEmpty()) { %>
                                    <div>
                                        <strong>Compétences requises:</strong>
                                        <p class="text-secondary"><%= offre.getCompetencesRequises() %></p>
                                    </div>
                                <% } %>
                                
                                <p class="text-muted mt-lg">
                                    Publié le <%= sdf.format(offre.getCreatedAt()) %>
                                </p>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="text-center text-muted">
                        Vous n'avez pas encore créé d'offres de stage. 
                        Cliquez sur "Creer une nouvelle offre" pour commencer.
                    </p>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Create Offer Modal -->
    <div id="offerModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeOfferModal()">&times;</span>
            <h2>Creer une offre de stage</h2>
            <form action="entreprise-offres" method="post">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="titre">Titre de l'offre *</label>
                    <input type="text" id="titre" name="titre" required
                           placeholder="Ex: Développeur Web Full Stack">
                </div>
                
                <div class="form-group">
                    <label for="description">Description *</label>
                    <textarea id="description" name="description" rows="4" required minlength="50"
                              placeholder="Décrivez l'offre de stage (minimum 50 caractères)..."></textarea>
                    <small class="form-text">Minimum 50 caractères</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="specialite">Spécialité *</label>
                        <select id="specialite" name="specialite" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Développement Web et Mobile">Développement Web et Mobile</option>
                            <option value="Développement Web">Développement Web</option>
                            <option value="Développement Mobile">Développement Mobile</option>
                            <option value="Data Science">Data Science</option>
                            <option value="Cyber Sécurité">Cyber Sécurité</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="typeStage">Type de stage *</label>
                        <select id="typeStage" name="typeStage" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Présentiel">Présentiel</option>
                            <option value="Apprentissage">Apprentissage</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="zone">Zone géographique *</label>
                        <select id="zone" name="zone" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Alger">Alger</option>
                            <option value="Oran">Oran</option>
                            <option value="Constantine">Constantine</option>
                            <option value="Annaba">Annaba</option>
                            <option value="Blida">Blida</option>
                            <option value="Sétif">Sétif</option>
                            <option value="Tipaza">Tipaza</option>
                            <option value="Béjaïa">Béjaïa</option>
                            <option value="Batna">Batna</option>
                            <option value="Tlemcen">Tlemcen</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="dureeMois">Durée (en mois) *</label>
                        <input type="number" id="dureeMois" name="dureeMois" required
                               min="1" max="48" placeholder="6">
                        <small class="form-text">Maximum 48 mois (4 ans)</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="remuneration">Rémunération</label>
                    <input type="text" id="remuneration" name="remuneration"
                           placeholder="Ex: 80 000 DZD/mois">
                </div>
                
                <div class="form-group">
                    <label for="competences">Compétences requises</label>
                    <textarea id="competences" name="competences" rows="3"
                              placeholder="Listez les compétences nécessaires..."></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="submit" class="btn btn-primary">Creer l'offre</button>
                    <button type="button" class="btn btn-secondary" onclick="closeOfferModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Edit Offer Modal -->
    <div id="editOfferModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h2>Modifier l'offre de stage</h2>
            <form action="entreprise-offres" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" id="editOffreId" name="offreId">
                
                <div class="form-group">
                    <label for="editTitre">Titre de l'offre *</label>
                    <input type="text" id="editTitre" name="titre" required>
                </div>
                
                <div class="form-group">
                    <label for="editDescription">Description *</label>
                    <textarea id="editDescription" name="description" rows="4" required minlength="50"></textarea>
                    <small class="form-text">Minimum 50 caractères</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="editSpecialite">Spécialité *</label>
                        <select id="editSpecialite" name="specialite" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Développement Web et Mobile">Développement Web et Mobile</option>
                            <option value="Développement Web">Développement Web</option>
                            <option value="Développement Mobile">Développement Mobile</option>
                            <option value="Data Science">Data Science</option>
                            <option value="Cyber Sécurité">Cyber Sécurité</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="editTypeStage">Type de stage *</label>
                        <select id="editTypeStage" name="typeStage" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Présentiel">Présentiel</option>
                            <option value="Apprentissage">Apprentissage</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="editZone">Zone géographique *</label>
                        <select id="editZone" name="zone" required>
                            <option value="">-- Sélectionnez --</option>
                            <option value="Alger">Alger</option>
                            <option value="Oran">Oran</option>
                            <option value="Constantine">Constantine</option>
                            <option value="Annaba">Annaba</option>
                            <option value="Blida">Blida</option>
                            <option value="Sétif">Sétif</option>
                            <option value="Tipaza">Tipaza</option>
                            <option value="Béjaïa">Béjaïa</option>
                            <option value="Batna">Batna</option>
                            <option value="Tlemcen">Tlemcen</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="editDureeMois">Durée (en mois) *</label>
                        <input type="number" id="editDureeMois" name="dureeMois" required min="1" max="48">
                        <small class="form-text">Maximum 48 mois (4 ans)</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="editRemuneration">Rémunération</label>
                    <input type="text" id="editRemuneration" name="remuneration">
                </div>
                
                <div class="form-group">
                    <label for="editCompetences">Compétences requises</label>
                    <textarea id="editCompetences" name="competences" rows="3"></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="submit" class="btn btn-primary">Sauvegarder</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDeleteModal()">&times;</span>
            <h2>Confirmer la suppression</h2>
            <p id="deleteMessage"></p>
            <form action="entreprise-offres" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="deleteOffreId" name="offreId">
                
                <div class="modal-actions">
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                    <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openOfferModal() {
            document.getElementById('offerModal').style.display = 'block';
        }
        
        function closeOfferModal() {
            document.getElementById('offerModal').style.display = 'none';
        }
        
        function openEditModal(id, titre, description, specialite, typeStage, zone, dureeMois, remuneration, competences) {
            document.getElementById('editOffreId').value = id;
            document.getElementById('editTitre').value = titre;
            document.getElementById('editDescription').value = description;
            document.getElementById('editSpecialite').value = specialite;
            document.getElementById('editTypeStage').value = typeStage;
            document.getElementById('editZone').value = zone;
            document.getElementById('editDureeMois').value = dureeMois;
            document.getElementById('editRemuneration').value = remuneration;
            document.getElementById('editCompetences').value = competences;
            document.getElementById('editOfferModal').style.display = 'block';
        }
        
        function closeEditModal() {
            document.getElementById('editOfferModal').style.display = 'none';
        }
        
        function confirmDelete(id, title) {
            document.getElementById('deleteOffreId').value = id;
            document.getElementById('deleteMessage').textContent = 
                'Êtes-vous sûr de vouloir supprimer l\'offre "' + title + '" ? Cette action est irréversible.';
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const offerModal = document.getElementById('offerModal');
            const editModal = document.getElementById('editOfferModal');
            const deleteModal = document.getElementById('deleteModal');
            if (event.target === offerModal) {
                closeOfferModal();
            }
            if (event.target === editModal) {
                closeEditModal();
            }
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>
