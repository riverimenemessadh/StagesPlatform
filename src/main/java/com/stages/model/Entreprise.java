package com.stages.model;

import java.sql.Timestamp;

public class Entreprise {
    private int id;
    private String nom;
    private String email;
    private String password;
    private String specialites; // Stored as comma-separated values
    private String zoneGeographique;
    private String adresse;
    private String secteur;
    private String description;
    private String telephone;
    private String siteWeb;
    private boolean profileCompleted;
    private Timestamp createdAt;
    
    // Constructors
    public Entreprise() {}
    
    public Entreprise(String nom, String email, String password) {
        this.nom = nom;
        this.email = email;
        this.password = password;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getSpecialites() { return specialites; }
    public void setSpecialites(String specialites) { this.specialites = specialites; }
    
    public String getZoneGeographique() { return zoneGeographique; }
    public void setZoneGeographique(String zoneGeographique) { this.zoneGeographique = zoneGeographique; }
    
    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    
    public String getSecteur() { return secteur; }
    public void setSecteur(String secteur) { this.secteur = secteur; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    
    public String getSiteWeb() { return siteWeb; }
    public void setSiteWeb(String siteWeb) { this.siteWeb = siteWeb; }
    
    public boolean isProfileCompleted() { return profileCompleted; }
    public void setProfileCompleted(boolean profileCompleted) { this.profileCompleted = profileCompleted; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
