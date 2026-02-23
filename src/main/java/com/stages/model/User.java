package com.stages.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String onefdId;
    private String nom;
    private String prenom;
    private String email;
    private String password;
    private String specialite;
    private String typeStage;
    private String zoneGeographique;
    private String telephone;
    private boolean profileCompleted;
    private Timestamp createdAt;
    
    // Constructors
    public User() {}
    
    public User(String nom, String prenom, String email, String password) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getOnefdId() { return onefdId; }
    public void setOnefdId(String onefdId) { this.onefdId = onefdId; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }
    
    public String getTypeStage() { return typeStage; }
    public void setTypeStage(String typeStage) { this.typeStage = typeStage; }
    
    public String getZoneGeographique() { return zoneGeographique; }
    public void setZoneGeographique(String zoneGeographique) { this.zoneGeographique = zoneGeographique; }
    
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    
    public boolean isProfileCompleted() { return profileCompleted; }
    public void setProfileCompleted(boolean profileCompleted) { this.profileCompleted = profileCompleted; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getFullName() {
        return prenom + " " + nom;
    }
}

