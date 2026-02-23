package com.stages.model;

import java.sql.Timestamp;

public class QuizAttempt {
    private int id;
    private int quizId;
    private int apprenantId;
    private int offreId;
    private double score;
    private int totalPoints;
    private int earnedPoints;
    private boolean passed;
    private Timestamp completedAt;
    
    // Additional fields for display
    private String quizTitre;
    private String apprenantNom;
    private String apprenantPrenom;
    private String offreTitre;
    
    // Constructors
    public QuizAttempt() {}
    
    public QuizAttempt(int quizId, int apprenantId, int offreId) {
        this.quizId = quizId;
        this.apprenantId = apprenantId;
        this.offreId = offreId;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    
    public int getApprenantId() { return apprenantId; }
    public void setApprenantId(int apprenantId) { this.apprenantId = apprenantId; }
    
    public int getOffreId() { return offreId; }
    public void setOffreId(int offreId) { this.offreId = offreId; }
    
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }
    
    public int getTotalPoints() { return totalPoints; }
    public void setTotalPoints(int totalPoints) { this.totalPoints = totalPoints; }
    
    public int getEarnedPoints() { return earnedPoints; }
    public void setEarnedPoints(int earnedPoints) { this.earnedPoints = earnedPoints; }
    
    public boolean isPassed() { return passed; }
    public void setPassed(boolean passed) { this.passed = passed; }
    
    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }
    
    public String getQuizTitre() { return quizTitre; }
    public void setQuizTitre(String quizTitre) { this.quizTitre = quizTitre; }
    
    public String getApprenantNom() { return apprenantNom; }
    public void setApprenantNom(String apprenantNom) { this.apprenantNom = apprenantNom; }
    
    public String getApprenantPrenom() { return apprenantPrenom; }
    public void setApprenantPrenom(String apprenantPrenom) { this.apprenantPrenom = apprenantPrenom; }
    
    public String getOffreTitre() { return offreTitre; }
    public void setOffreTitre(String offreTitre) { this.offreTitre = offreTitre; }
    
    public String getApprenantFullName() {
        return apprenantPrenom + " " + apprenantNom;
    }
    
    public String getScoreFormatted() {
        return String.format("%.1f%%", score);
    }
    
    public String getPassStatusText() {
        return passed ? "Reussi" : "Echoue";
    }
}
