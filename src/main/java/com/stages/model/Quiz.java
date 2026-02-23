package com.stages.model;

import java.sql.Timestamp;

public class Quiz {
    private int id;
    private int entrepriseId;
    private String titre;
    private String description;
    private int passingScore;
    private Timestamp createdAt;
    
    // Additional fields for display
    private String entrepriseName;
    private int questionCount;
    
    // Constructors
    public Quiz() {}
    
    public Quiz(int entrepriseId, String titre, String description, int passingScore) {
        this.entrepriseId = entrepriseId;
        this.titre = titre;
        this.description = description;
        this.passingScore = passingScore;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getEntrepriseId() { return entrepriseId; }
    public void setEntrepriseId(int entrepriseId) { this.entrepriseId = entrepriseId; }
    
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getPassingScore() { return passingScore; }
    public void setPassingScore(int passingScore) { this.passingScore = passingScore; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getEntrepriseName() { return entrepriseName; }
    public void setEntrepriseName(String entrepriseName) { this.entrepriseName = entrepriseName; }
    
    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }
}
