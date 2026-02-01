package com.stages.dao;

import com.stages.model.OffreStage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OffreStageDAO {
    
    // Get all active offers
    public List<OffreStage> getAllOffres() {
        List<OffreStage> offres = new ArrayList<>();
        String sql = "SELECT o.*, e.nom as entreprise_name FROM offre_stage o " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE o.statut = 'active' ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                offres.add(extractOffreFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offres;
    }
    
    // Get offer by ID
    public OffreStage getOffreById(int id) {
        String sql = "SELECT o.*, e.nom as entreprise_name FROM offre_stage o " +
                    "JOIN entreprise e ON o.entreprise_id = e.id WHERE o.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractOffreFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Search and filter offers
    public List<OffreStage> searchOffres(String specialite, String zone, String type) {
        List<OffreStage> offres = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT o.*, e.nom as entreprise_name FROM offre_stage o " +
            "JOIN entreprise e ON o.entreprise_id = e.id WHERE o.statut = 'active'"
        );
        
        List<String> conditions = new ArrayList<>();
        
        if (specialite != null && !specialite.isEmpty()) {
            conditions.add("o.specialite = ?");
        }
        if (zone != null && !zone.isEmpty()) {
            conditions.add("o.zone_geographique = ?");
        }
        if (type != null && !type.isEmpty()) {
            conditions.add("o.type_stage = ?");
        }
        
        if (!conditions.isEmpty()) {
            sql.append(" AND ").append(String.join(" AND ", conditions));
        }
        
        sql.append(" ORDER BY o.created_at DESC");
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (specialite != null && !specialite.isEmpty()) {
                stmt.setString(paramIndex++, specialite);
            }
            if (zone != null && !zone.isEmpty()) {
                stmt.setString(paramIndex++, zone);
            }
            if (type != null && !type.isEmpty()) {
                stmt.setString(paramIndex++, type);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                offres.add(extractOffreFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offres;
    }
    
    // Get distinct specialties for filter
    public List<String> getDistinctSpecialites() {
        List<String> specialites = new ArrayList<>();
        String sql = "SELECT DISTINCT specialite FROM offre_stage WHERE statut = 'active' ORDER BY specialite";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                specialites.add(rs.getString("specialite"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return specialites;
    }
    
    // Get distinct zones for filter
    public List<String> getDistinctZones() {
        List<String> zones = new ArrayList<>();
        String sql = "SELECT DISTINCT zone_geographique FROM offre_stage WHERE statut = 'active' ORDER BY zone_geographique";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                zones.add(rs.getString("zone_geographique"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return zones;
    }
    
    // Get recent offers (limited number)
    public List<OffreStage> getRecentOffres(int limit) {
        List<OffreStage> offres = new ArrayList<>();
        String sql = "SELECT o.*, e.nom as entreprise_name FROM offre_stage o " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "ORDER BY o.created_at DESC LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                offres.add(extractOffreFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offres;
    }
    
    // Get offers by entreprise ID
    public List<OffreStage> getOffresByEntreprise(int entrepriseId) {
        List<OffreStage> offres = new ArrayList<>();
        String sql = "SELECT o.*, e.nom as entreprise_name FROM offre_stage o " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE o.entreprise_id = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entrepriseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                offres.add(extractOffreFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offres;
    }
    
    // Create new offer
    public boolean createOffre(OffreStage offre) {
        String sql = "INSERT INTO offre_stage (titre, description, entreprise_id, specialite, type_stage, " +
                    "zone_geographique, duree_mois, remuneration, " +
                    "competences_requises, statut) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, offre.getTitre());
            stmt.setString(2, offre.getDescription());
            stmt.setInt(3, offre.getEntrepriseId());
            stmt.setString(4, offre.getSpecialite());
            stmt.setString(5, offre.getTypeStage());
            stmt.setString(6, offre.getZoneGeographique());
            stmt.setInt(7, offre.getDureeMois());
            stmt.setString(8, offre.getRemuneration());
            stmt.setString(9, offre.getCompetencesRequises());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    offre.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error creating offer: " + e.getMessage());
        }
        return false;
    }
    
    // Update offer
    public boolean updateOffre(OffreStage offre) {
        String sql = "UPDATE offre_stage SET titre = ?, description = ?, specialite = ?, " +
                    "type_stage = ?, zone_geographique = ?, duree_mois = ?, remuneration = ?, " +
                    "competences_requises = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, offre.getTitre());
            stmt.setString(2, offre.getDescription());
            stmt.setString(3, offre.getSpecialite());
            stmt.setString(4, offre.getTypeStage());
            stmt.setString(5, offre.getZoneGeographique());
            stmt.setInt(6, offre.getDureeMois());
            stmt.setString(7, offre.getRemuneration());
            stmt.setString(8, offre.getCompetencesRequises());
            stmt.setInt(9, offre.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete offer
    public boolean deleteOffre(int id) {
        String sql = "DELETE FROM offre_stage WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get total offers count
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM offre_stage";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Helper method
    private OffreStage extractOffreFromResultSet(ResultSet rs) throws SQLException {
        OffreStage offre = new OffreStage();
        offre.setId(rs.getInt("id"));
        offre.setTitre(rs.getString("titre"));
        offre.setDescription(rs.getString("description"));
        offre.setEntrepriseId(rs.getInt("entreprise_id"));
        offre.setEntrepriseName(rs.getString("entreprise_name"));
        offre.setSpecialite(rs.getString("specialite"));
        offre.setTypeStage(rs.getString("type_stage"));
        offre.setZoneGeographique(rs.getString("zone_geographique"));
        offre.setDureeMois(rs.getInt("duree_mois"));
        offre.setRemuneration(rs.getString("remuneration"));
        offre.setCompetencesRequises(rs.getString("competences_requises"));
        offre.setStatut(rs.getString("statut"));
        offre.setCreatedAt(rs.getTimestamp("created_at"));
        return offre;
    }
}
