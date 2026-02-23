<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, com.stages.dao.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
    if (entreprise == null) {
        response.sendRedirect("login");
        return;
    }
    
    List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
    if (offres == null) {
        offres = new ArrayList<>();
    }
    
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    if (quizzes == null) {
        quizzes = new ArrayList<>();
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    QuizDAO quizDAO = new QuizDAO();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Offres - StageConnect</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
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
                            <div class="offer-card mb-lg" id="offer-<%= offre.getId() %>">
                                <div class="offer-header">
                                    <h3><%= offre.getTitre() %></h3>
                                    <div class="offer-actions">
                                        <button onclick="openEditModalById(<%= offre.getId() %>)" 
                                                class="btn btn-sm btn-secondary">
                                            Modifier
                                        </button>
                                        <button onclick="confirmDeleteById(<%= offre.getId() %>)" 
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
                                    <% if (offre.hasQuiz()) { %>
                                        <div>
                                            <strong>Quiz:</strong> 
                                            <span class="badge badge-info">Quiz Requis</span>
                                            <button type="button" class="btn btn-sm btn-info ml-sm" onclick="openQuizModal(<%= offre.getId() %>)">
                                                Voir Questions
                                            </button>
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
                
                <hr class="my-lg">
                
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="includeQuiz" name="includeQuiz" onchange="toggleQuizSection()">
                        Ajouter un quiz de competences
                    </label>
                    <small class="form-text">Les candidats devront completer le quiz pour postuler</small>
                </div>
                
                <div id="quizSection" style="display: none;">
                    <div class="quiz-inline-section">
                        <h3>Questions du Quiz</h3>
                        <small class="form-text mb-md">Ajoutez au moins 3 questions (maximum 10)</small>
                        
                        <div id="questionsContainer">
                            <!-- Questions will be added here dynamically -->
                        </div>
                        
                        <button type="button" class="btn btn-secondary btn-block mt-md" onclick="addQuizQuestion()">
                            Ajouter une question
                        </button>
                    </div>
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
            <form id="editOfferForm" action="entreprise-offres" method="post" onsubmit="return validateEditForm(event)">
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
                
                <hr class="my-lg">
                
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="editIncludeQuiz" name="includeQuiz" onchange="toggleEditQuizSection()">
                        Ajouter/Modifier le quiz de competences
                    </label>
                    <small class="form-text">Les candidats devront completer le quiz pour postuler</small>
                </div>
                
                <div id="editQuizSection" style="display: none;">
                    <div class="quiz-inline-section">
                        <h3>Questions du Quiz</h3>
                        <small class="form-text mb-md">Ajoutez au moins 3 questions (maximum 10)</small>
                        
                        <div id="editQuestionsContainer">
                            <!-- Questions will be loaded/added here -->
                        </div>
                        
                        <button type="button" class="btn btn-secondary btn-block mt-md" onclick="addEditQuizQuestion()">
                            Ajouter une question
                        </button>
                    </div>
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
    
    <!-- Quiz Questions View Modal -->
    <div id="quizModal" class="modal">
        <div class="modal-content modal-large">
            <span class="close" onclick="closeQuizModal()">&times;</span>
            <h2 id="quizModalTitle">Questions du Quiz</h2>
            <div id="quizModalContent" class="quiz-modal-body">
                <!-- Quiz questions will be populated here -->
            </div>
        </div>
    </div>
    
    <script>
        // Store all offer data - populated from server
        var offerData = {};
        var offerQuizData = {};
        
        <% 
        if (offres != null && !offres.isEmpty()) {
            for (OffreStage offre : offres) { 
                String titre = offre.getTitre() != null ? offre.getTitre().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
                String description = offre.getDescription() != null ? offre.getDescription().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
                String remuneration = offre.getRemuneration() != null ? offre.getRemuneration().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"") : "";
                String competences = offre.getCompetencesRequises() != null ? offre.getCompetencesRequises().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
        %>
        offerData[<%= offre.getId() %>] = {
            id: <%= offre.getId() %>,
            titre: '<%= titre %>',
            description: '<%= description %>',
            specialite: '<%= offre.getSpecialite() %>',
            typeStage: '<%= offre.getTypeStage() %>',
            zone: '<%= offre.getZoneGeographique() %>',
            dureeMois: <%= offre.getDureeMois() %>,
            remuneration: '<%= remuneration %>',
            competences: '<%= competences %>',
            quizId: <%= offre.hasQuiz() && offre.getQuizId() != null ? offre.getQuizId() : "null" %>
        };
        <%
                // Load quiz questions if this offer has a quiz
                if (offre.hasQuiz() && offre.getQuizId() != null) {
                    List<QuizQuestion> questions = quizDAO.getQuestionsByQuizId(offre.getQuizId());
                    if (questions != null && !questions.isEmpty()) {
        %>
        offerQuizData[<%= offre.getId() %>] = {
            quizId: <%= offre.getQuizId() %>,
            questions: [
                <% 
                for (int i = 0; i < questions.size(); i++) { 
                    QuizQuestion q = questions.get(i);
                    if (i > 0) out.print(",");
                    String questionText = q.getQuestionText() != null ? q.getQuestionText().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
                    String optionA = q.getOptionA() != null ? q.getOptionA().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"") : "";
                    String optionB = q.getOptionB() != null ? q.getOptionB().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"") : "";
                    String optionC = q.getOptionC() != null ? q.getOptionC().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"") : "";
                    String optionD = q.getOptionD() != null ? q.getOptionD().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"") : "";
                    String correctAnswer = q.getCorrectAnswer() != null ? q.getCorrectAnswer() : "";
                %>
                {
                    id: <%= q.getId() %>,
                    questionText: '<%= questionText %>',
                    optionA: '<%= optionA %>',
                    optionB: '<%= optionB %>',
                    optionC: '<%= optionC %>',
                    optionD: '<%= optionD %>',
                    correctAnswer: '<%= correctAnswer %>',
                    points: <%= q.getPoints() %>
                }
                <% } %>
            ]
        };
        <%
                    }
                }
            }
        }
        %>
        
        function openOfferModal() {
            document.getElementById('offerModal').style.display = 'block';
        }
        
        function closeOfferModal() {
            document.getElementById('offerModal').style.display = 'none';
            document.getElementById('includeQuiz').checked = false;
            document.getElementById('quizSection').style.display = 'none';
            document.getElementById('questionsContainer').innerHTML = '';
            questionCount = 0;
        }
        
        var questionCount = 0;
        var questionIdCounter = 0;
        
        function toggleQuizSection() {
            var checkbox = document.getElementById('includeQuiz');
            var section = document.getElementById('quizSection');
            if (checkbox.checked) {
                section.style.display = 'block';
                if (questionCount === 0) {
                    addQuizQuestion();
                    addQuizQuestion();
                    addQuizQuestion();
                }
            } else {
                section.style.display = 'none';
            }
        }
        
        function addQuizQuestion() {
            var container = document.getElementById('questionsContainer');
            var actualCount = container.querySelectorAll('.quiz-question-item').length;
            
            if (actualCount >= 10) {
                alert('Maximum 10 questions par quiz');
                return;
            }
            
            questionIdCounter++;
            var currentId = questionIdCounter;
            var num = actualCount + 1;
            
            var questionDiv = document.createElement('div');
            questionDiv.className = 'quiz-question-item';
            questionDiv.setAttribute('data-question-id', currentId);
            questionDiv.innerHTML = 
                '<div class="question-header">' +
                    '<span class="question-number">Question ' + num + '</span>' +
                    '<button type="button" class="btn-remove-question" onclick="removeQuizQuestion(' + currentId + ')">Supprimer</button>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label>Texte de la question *</label>' +
                    '<input type="text" name="question_' + num + '" class="question-input" required placeholder="Ex: Quel est le langage de programmation cote client?">' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Option A *</label>' +
                        '<input type="text" name="optionA_' + num + '" class="optionA-input" required placeholder="Option A">' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Option B *</label>' +
                        '<input type="text" name="optionB_' + num + '" class="optionB-input" required placeholder="Option B">' +
                    '</div>' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Option C *</label>' +
                        '<input type="text" name="optionC_' + num + '" class="optionC-input" required placeholder="Option C">' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Option D *</label>' +
                        '<input type="text" name="optionD_' + num + '" class="optionD-input" required placeholder="Option D">' +
                    '</div>' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Reponse correcte *</label>' +
                        '<select name="correctAnswer_' + num + '" class="correctAnswer-input" required>' +
                            '<option value="">-- Selectionnez --</option>' +
                            '<option value="a">Option A</option>' +
                            '<option value="b">Option B</option>' +
                            '<option value="c">Option C</option>' +
                            '<option value="d">Option D</option>' +
                        '</select>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Points</label>' +
                        '<input type="number" name="points_' + num + '" class="points-input" value="5" min="1" max="10">' +
                    '</div>' +
                '</div>';
            
            container.appendChild(questionDiv);
            questionCount = actualCount + 1;
        }
        
        function removeQuizQuestion(id) {
            var container = document.getElementById('questionsContainer');
            var currentQuestions = container.querySelectorAll('.quiz-question-item');
            
            if (currentQuestions.length <= 3) {
                alert('Le quiz doit contenir au moins 3 questions.');
                return;
            }
            
            var questionDiv = container.querySelector('[data-question-id="' + id + '"]');
            if (questionDiv) {
                questionDiv.remove();
                var questions = container.querySelectorAll('.quiz-question-item');
                questionCount = questions.length;
                questions.forEach(function(q, index) {
                    var num = index + 1;
                    q.querySelector('.question-number').textContent = 'Question ' + num;
                    q.querySelector('.question-input').name = 'question_' + num;
                    q.querySelector('.optionA-input').name = 'optionA_' + num;
                    q.querySelector('.optionB-input').name = 'optionB_' + num;
                    q.querySelector('.optionC-input').name = 'optionC_' + num;
                    q.querySelector('.optionD-input').name = 'optionD_' + num;
                    q.querySelector('.correctAnswer-input').name = 'correctAnswer_' + num;
                    q.querySelector('.points-input').name = 'points_' + num;
                });
            }
        }
        
        var editQuestionCount = 0;
        var editQuestionIdCounter = 0;
        
        function toggleEditQuizSection() {
            var checkbox = document.getElementById('editIncludeQuiz');
            var section = document.getElementById('editQuizSection');
            if (checkbox.checked) {
                section.style.display = 'block';
            } else {
                section.style.display = 'none';
            }
        }
        
        function addEditQuizQuestion() {
            var container = document.getElementById('editQuestionsContainer');
            var actualCount = container.querySelectorAll('.quiz-question-item').length;
            
            if (actualCount >= 10) {
                alert('Maximum 10 questions par quiz');
                return;
            }
            
            editQuestionIdCounter++;
            var currentId = editQuestionIdCounter;
            var num = actualCount + 1;
            
            var questionDiv = document.createElement('div');
            questionDiv.className = 'quiz-question-item';
            questionDiv.setAttribute('data-question-id', currentId);
            questionDiv.innerHTML = 
                '<div class="question-header">' +
                    '<span class="question-number">Question ' + num + '</span>' +
                    '<button type="button" class="btn-remove-question" onclick="removeEditQuizQuestion(' + currentId + ')">Supprimer</button>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label>Texte de la question *</label>' +
                    '<input type="text" name="question_' + num + '" class="question-input" required placeholder="Ex: Quel est le langage de programmation cote client?">' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Option A *</label>' +
                        '<input type="text" name="optionA_' + num + '" class="optionA-input" required placeholder="Option A">' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Option B *</label>' +
                        '<input type="text" name="optionB_' + num + '" class="optionB-input" required placeholder="Option B">' +
                    '</div>' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Option C *</label>' +
                        '<input type="text" name="optionC_' + num + '" class="optionC-input" required placeholder="Option C">' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Option D *</label>' +
                        '<input type="text" name="optionD_' + num + '" class="optionD-input" required placeholder="Option D">' +
                    '</div>' +
                '</div>' +
                '<div class="form-row">' +
                    '<div class="form-group">' +
                        '<label>Reponse correcte *</label>' +
                        '<select name="correctAnswer_' + num + '" class="correctAnswer-input" required>' +
                            '<option value="">-- Selectionnez --</option>' +
                            '<option value="a">Option A</option>' +
                            '<option value="b">Option B</option>' +
                            '<option value="c">Option C</option>' +
                            '<option value="d">Option D</option>' +
                        '</select>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label>Points</label>' +
                        '<input type="number" name="points_' + num + '" class="points-input" value="5" min="1" max="10">' +
                    '</div>' +
                '</div>';
            
            container.appendChild(questionDiv);
            editQuestionCount = actualCount + 1;
        }
        
        function removeEditQuizQuestion(id) {
            var container = document.getElementById('editQuestionsContainer');
            var currentQuestions = container.querySelectorAll('.quiz-question-item');
            
            if (currentQuestions.length <= 3) {
                alert('Le quiz doit contenir au moins 3 questions.');
                return;
            }
            
            var questionDiv = container.querySelector('[data-question-id="' + id + '"]');
            if (questionDiv) {
                questionDiv.remove();
                var questions = container.querySelectorAll('.quiz-question-item');
                editQuestionCount = questions.length;
                questions.forEach(function(q, index) {
                    var num = index + 1;
                    q.querySelector('.question-number').textContent = 'Question ' + num;
                    q.querySelector('.question-input').name = 'question_' + num;
                    q.querySelector('.optionA-input').name = 'optionA_' + num;
                    q.querySelector('.optionB-input').name = 'optionB_' + num;
                    q.querySelector('.optionC-input').name = 'optionC_' + num;
                    q.querySelector('.optionD-input').name = 'optionD_' + num;
                    q.querySelector('.correctAnswer-input').name = 'correctAnswer_' + num;
                    q.querySelector('.points-input').name = 'points_' + num;
                });
            }
        }
        
        function openQuizModal(offerId) {
            const offer = offerData[offerId];
            const quizData = offerQuizData[offerId];
            
            if (!offer || !quizData) {
                alert('Aucune question trouvee pour cette offre.');
                return;
            }
            
            // Set modal title
            document.getElementById('quizModalTitle').textContent = 'Quiz: ' + offer.titre;
            
            // Build quiz content
            let content = '<div class="quiz-questions-display">';
            
            quizData.questions.forEach(function(q, index) {
                content += '<div class="quiz-question-display-item">';
                content += '    <p class="question-text"><strong>Q' + (index + 1) + ':</strong> ' + q.questionText + '</p>';
                content += '    <div class="options-list">';
                content += '        <p>A) ' + q.optionA + '</p>';
                content += '        <p>B) ' + q.optionB + '</p>';
                content += '        <p>C) ' + q.optionC + '</p>';
                content += '        <p>D) ' + q.optionD + '</p>';
                content += '    </div>';
                content += '    <p class="correct-answer-display">';
                content += '        <strong>Reponse correcte:</strong> ';
                content += '        <span class="text-success">' + q.correctAnswer.toUpperCase() + '</span>';
                content += '        (' + q.points + ' points)';
                content += '    </p>';
                content += '</div>';
            });
            
            content += '</div>';
            
            // Set content
            document.getElementById('quizModalContent').innerHTML = content;
            
            // Show modal
            document.getElementById('quizModal').style.display = 'block';
        }
        
        function closeQuizModal() {
            document.getElementById('quizModal').style.display = 'none';
        }
        
        let originalFormData = {};
        
        function captureOriginalFormData() {
            const form = document.getElementById('editOfferForm');
            originalFormData = {
                titre: form.querySelector('#editTitre').value,
                description: form.querySelector('#editDescription').value,
                specialite: form.querySelector('#editSpecialite').value,
                typeStage: form.querySelector('#editTypeStage').value,
                zone: form.querySelector('#editZone').value,
                dureeMois: form.querySelector('#editDureeMois').value,
                remuneration: form.querySelector('#editRemuneration').value,
                competences: form.querySelector('#editCompetences').value,
                includeQuiz: form.querySelector('#editIncludeQuiz').checked,
                questions: []
            };
            
            // Capture quiz questions if present
            const questionItems = form.querySelectorAll('.quiz-question-item');
            questionItems.forEach(function(item) {
                const questionData = {
                    text: item.querySelector('.question-input').value,
                    optionA: item.querySelector('.optionA-input').value,
                    optionB: item.querySelector('.optionB-input').value,
                    optionC: item.querySelector('.optionC-input').value,
                    optionD: item.querySelector('.optionD-input').value,
                    correctAnswer: item.querySelector('.correctAnswer-input').value,
                    points: item.querySelector('.points-input').value
                };
                originalFormData.questions.push(questionData);
            });
        }
        
        function validateEditForm(event) {
            const form = document.getElementById('editOfferForm');
            const currentData = {
                titre: form.querySelector('#editTitre').value,
                description: form.querySelector('#editDescription').value,
                specialite: form.querySelector('#editSpecialite').value,
                typeStage: form.querySelector('#editTypeStage').value,
                zone: form.querySelector('#editZone').value,
                dureeMois: form.querySelector('#editDureeMois').value,
                remuneration: form.querySelector('#editRemuneration').value,
                competences: form.querySelector('#editCompetences').value,
                includeQuiz: form.querySelector('#editIncludeQuiz').checked,
                questions: []
            };
            
            // Capture current quiz questions
            const questionItems = form.querySelectorAll('.quiz-question-item');
            questionItems.forEach(function(item) {
                const questionData = {
                    text: item.querySelector('.question-input').value,
                    optionA: item.querySelector('.optionA-input').value,
                    optionB: item.querySelector('.optionB-input').value,
                    optionC: item.querySelector('.optionC-input').value,
                    optionD: item.querySelector('.optionD-input').value,
                    correctAnswer: item.querySelector('.correctAnswer-input').value,
                    points: item.querySelector('.points-input').value
                };
                currentData.questions.push(questionData);
            });
            
            // Compare offer fields
            let hasChanges = false;
            if (currentData.titre !== originalFormData.titre ||
                currentData.description !== originalFormData.description ||
                currentData.specialite !== originalFormData.specialite ||
                currentData.typeStage !== originalFormData.typeStage ||
                currentData.zone !== originalFormData.zone ||
                currentData.dureeMois !== originalFormData.dureeMois ||
                currentData.remuneration !== originalFormData.remuneration ||
                currentData.competences !== originalFormData.competences ||
                currentData.includeQuiz !== originalFormData.includeQuiz) {
                hasChanges = true;
            }
            
            // Compare quiz questions
            if (!hasChanges) {
                if (currentData.questions.length !== originalFormData.questions.length) {
                    hasChanges = true;
                } else {
                    for (let i = 0; i < currentData.questions.length; i++) {
                        const curr = currentData.questions[i];
                        const orig = originalFormData.questions[i];
                        if (curr.text !== orig.text ||
                            curr.optionA !== orig.optionA ||
                            curr.optionB !== orig.optionB ||
                            curr.optionC !== orig.optionC ||
                            curr.optionD !== orig.optionD ||
                            curr.correctAnswer !== orig.correctAnswer ||
                            curr.points !== orig.points) {
                            hasChanges = true;
                            break;
                        }
                    }
                }
            }
            
            if (!hasChanges) {
                event.preventDefault();
                alert('Aucune modification detectee. Veuillez modifier au moins un champ avant de soumettre.');
                return false;
            }
            
            return true;
        }
        
        function openEditModalById(id) {
            var offer = offerData[id];
            if (!offer) {
                alert('Erreur: Offre introuvable');
                return;
            }
            
            document.getElementById('editOffreId').value = offer.id;
            document.getElementById('editTitre').value = offer.titre;
            document.getElementById('editDescription').value = offer.description;
            document.getElementById('editSpecialite').value = offer.specialite;
            document.getElementById('editTypeStage').value = offer.typeStage;
            document.getElementById('editZone').value = offer.zone;
            document.getElementById('editDureeMois').value = offer.dureeMois;
            document.getElementById('editRemuneration').value = offer.remuneration;
            document.getElementById('editCompetences').value = offer.competences;
            
            document.getElementById('editIncludeQuiz').checked = false;
            document.getElementById('editQuizSection').style.display = 'none';
            document.getElementById('editQuestionsContainer').innerHTML = '';
            editQuestionCount = 0;
            editQuestionIdCounter = 0;
            
            if (offer.quizId && offerQuizData[id]) {
                var quizData = offerQuizData[id];
                document.getElementById('editIncludeQuiz').checked = true;
                document.getElementById('editQuizSection').style.display = 'block';
                
                quizData.questions.forEach(function(q, index) {
                    editQuestionIdCounter++;
                    var currentId = editQuestionIdCounter;
                    var container = document.getElementById('editQuestionsContainer');
                    var num = index + 1;
                    
                    var selectedA = q.correctAnswer === 'a' ? 'selected' : '';
                    var selectedB = q.correctAnswer === 'b' ? 'selected' : '';
                    var selectedC = q.correctAnswer === 'c' ? 'selected' : '';
                    var selectedD = q.correctAnswer === 'd' ? 'selected' : '';
                    
                    var questionDiv = document.createElement('div');
                    questionDiv.className = 'quiz-question-item';
                    questionDiv.setAttribute('data-question-id', currentId);
                    questionDiv.innerHTML = 
                        '<div class="question-header">' +
                            '<span class="question-number">Question ' + num + '</span>' +
                            '<button type="button" class="btn-remove-question" onclick="removeEditQuizQuestion(' + currentId + ')">Supprimer</button>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Texte de la question *</label>' +
                            '<input type="text" name="question_' + num + '" class="question-input" required value="' + q.questionText + '" placeholder="Ex: Quel est le langage de programmation cote client?">' +
                        '</div>' +
                        '<div class="form-row">' +
                            '<div class="form-group">' +
                                '<label>Option A *</label>' +
                                '<input type="text" name="optionA_' + num + '" class="optionA-input" required value="' + q.optionA + '" placeholder="Option A">' +
                            '</div>' +
                            '<div class="form-group">' +
                                '<label>Option B *</label>' +
                                '<input type="text" name="optionB_' + num + '" class="optionB-input" required value="' + q.optionB + '" placeholder="Option B">' +
                            '</div>' +
                        '</div>' +
                        '<div class="form-row">' +
                            '<div class="form-group">' +
                                '<label>Option C *</label>' +
                                '<input type="text" name="optionC_' + num + '" class="optionC-input" required value="' + q.optionC + '" placeholder="Option C">' +
                            '</div>' +
                            '<div class="form-group">' +
                                '<label>Option D *</label>' +
                                '<input type="text" name="optionD_' + num + '" class="optionD-input" required value="' + q.optionD + '" placeholder="Option D">' +
                            '</div>' +
                        '</div>' +
                        '<div class="form-row">' +
                            '<div class="form-group">' +
                                '<label>Reponse correcte *</label>' +
                                '<select name="correctAnswer_' + num + '" class="correctAnswer-input" required>' +
                                    '<option value="">-- Selectionnez --</option>' +
                                    '<option value="a" ' + selectedA + '>Option A</option>' +
                                    '<option value="b" ' + selectedB + '>Option B</option>' +
                                    '<option value="c" ' + selectedC + '>Option C</option>' +
                                    '<option value="d" ' + selectedD + '>Option D</option>' +
                                '</select>' +
                            '</div>' +
                            '<div class="form-group">' +
                                '<label>Points</label>' +
                                '<input type="number" name="points_' + num + '" class="points-input" value="' + q.points + '" min="1" max="10">' +
                            '</div>' +
                        '</div>';
                    
                    container.appendChild(questionDiv);
                    editQuestionCount++;
                });
            }
            
            document.getElementById('editOfferModal').style.display = 'block';
            
            // Capture original form data for change detection
            setTimeout(captureOriginalFormData, 100);
        }
        
        function closeEditModal() {
            document.getElementById('editOfferModal').style.display = 'none';
        }
        
        function confirmDeleteById(id) {
            var offer = offerData[id];
            if (!offer) {
                alert('Erreur: Offre introuvable');
                return;
            }
            
            document.getElementById('deleteOffreId').value = id;
            document.getElementById('deleteMessage').textContent = 
                'Êtes-vous sûr de vouloir supprimer l\'offre "' + offer.titre + '" ? Cette action est irréversible.';
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            var offerModal = document.getElementById('offerModal');
            var editModal = document.getElementById('editOfferModal');
            var deleteModal = document.getElementById('deleteModal');
            const quizModal = document.getElementById('quizModal');
            
            if (event.target === offerModal) {
                closeOfferModal();
            }
            if (event.target === editModal) {
                closeEditModal();
            }
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
            if (event.target === quizModal) {
                closeQuizModal();
            }
        }
    </script>
</body>
</html>
