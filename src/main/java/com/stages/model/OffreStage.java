package com.stages.model;

import java.sql.Timestamp;

public class OffreStage {
    private int id;
    private String titre;
    private String description;
    private int entrepriseId;
    private String entrepriseName; // For display purposes
    private String specialite;
    private String typeStage;
    private String zoneGeographique;
    private int dureeMois;
    private String remuneration;
    private String competencesRequises;
    private Integer quizId;
    private String quizTitre;
    private String statut;
    private Timestamp createdAt;
    
    // Constructors
    public OffreStage() {}
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getEntrepriseId() { return entrepriseId; }
    public void setEntrepriseId(int entrepriseId) { this.entrepriseId = entrepriseId; }
    
    public String getEntrepriseName() { return entrepriseName; }
    public void setEntrepriseName(String entrepriseName) { this.entrepriseName = entrepriseName; }
    
    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }
    
    public String getTypeStage() { return typeStage; }
    public void setTypeStage(String typeStage) { this.typeStage = typeStage; }
    
    public String getZoneGeographique() { return zoneGeographique; }
    public void setZoneGeographique(String zoneGeographique) { this.zoneGeographique = zoneGeographique; }
    
    public int getDureeMois() { return dureeMois; }
    public void setDureeMois(int dureeMois) { this.dureeMois = dureeMois; }
    
    public String getRemuneration() { return remuneration; }
    public void setRemuneration(String remuneration) { this.remuneration = remuneration; }
    
    public String getCompetencesRequises() { return competencesRequises; }
    public void setCompetencesRequises(String competencesRequises) { this.competencesRequises = competencesRequises; }
    
    public Integer getQuizId() { return quizId; }
    public void setQuizId(Integer quizId) { this.quizId = quizId; }
    
    public String getQuizTitre() { return quizTitre; }
    public void setQuizTitre(String quizTitre) { this.quizTitre = quizTitre; }
    
    public boolean hasQuiz() { return quizId != null && quizId > 0; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
