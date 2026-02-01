package com.stages.model;

import java.sql.Timestamp;

public class Candidature {
    private int id;
    private int apprenantId;
    private int offreId;
    private String statut;
    private Timestamp dateCandidature;
    private String lettreMotivation;
    private Timestamp dateReponse;
    private String commentaireAdmin;
    
    // Additional fields for display
    private String apprenantNom;
    private String apprenantPrenom;
    private String apprenantEmail;
    private String offreTitre;
    private String entrepriseName;
    
    // Constructors
    public Candidature() {}
    
    public Candidature(int apprenantId, int offreId) {
        this.apprenantId = apprenantId;
        this.offreId = offreId;
        this.statut = "En attente";
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getApprenantId() { return apprenantId; }
    public void setApprenantId(int apprenantId) { this.apprenantId = apprenantId; }
    
    public int getOffreId() { return offreId; }
    public void setOffreId(int offreId) { this.offreId = offreId; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public Timestamp getDateCandidature() { return dateCandidature; }
    public void setDateCandidature(Timestamp dateCandidature) { this.dateCandidature = dateCandidature; }
    
    public String getLettreMotivation() { return lettreMotivation; }
    public void setLettreMotivation(String lettreMotivation) { this.lettreMotivation = lettreMotivation; }
    
    public Timestamp getDateReponse() { return dateReponse; }
    public void setDateReponse(Timestamp dateReponse) { this.dateReponse = dateReponse; }
    
    public String getCommentaireAdmin() { return commentaireAdmin; }
    public void setCommentaireAdmin(String commentaireAdmin) { this.commentaireAdmin = commentaireAdmin; }
    
    public String getApprenantNom() { return apprenantNom; }
    public void setApprenantNom(String apprenantNom) { this.apprenantNom = apprenantNom; }
    
    public String getApprenantPrenom() { return apprenantPrenom; }
    public void setApprenantPrenom(String apprenantPrenom) { this.apprenantPrenom = apprenantPrenom; }
    
    public String getApprenantEmail() { return apprenantEmail; }
    public void setApprenantEmail(String apprenantEmail) { this.apprenantEmail = apprenantEmail; }
    
    public String getOffreTitre() { return offreTitre; }
    public void setOffreTitre(String offreTitre) { this.offreTitre = offreTitre; }
    
    public String getEntrepriseName() { return entrepriseName; }
    public void setEntrepriseName(String entrepriseName) { this.entrepriseName = entrepriseName; }
    
    public String getApprenantFullName() {
        return apprenantPrenom + " " + apprenantNom;
    }
}

