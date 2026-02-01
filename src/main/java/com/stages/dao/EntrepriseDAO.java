package com.stages.dao;

import com.stages.model.Entreprise;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EntrepriseDAO {
    
    // Authenticate enterprise
    public Entreprise authenticate(String email, String password) {
        String sql = "SELECT * FROM entreprise WHERE email = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractEntrepriseFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Register new enterprise
    public boolean register(Entreprise entreprise) {
        String sql = "INSERT INTO entreprise (nom, email, password, profile_completed) VALUES (?, ?, ?, FALSE)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, entreprise.getNom());
            stmt.setString(2, entreprise.getEmail());
            stmt.setString(3, entreprise.getPassword());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    entreprise.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM entreprise WHERE email = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update enterprise profile
    public boolean updateProfile(Entreprise entreprise) {
        String sql = "UPDATE entreprise SET specialites = ?, zone_geographique = ?, " +
                    "adresse = ?, secteur = ?, description = ?, telephone = ?, site_web = ?, " +
                    "profile_completed = TRUE WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, entreprise.getSpecialites());
            stmt.setString(2, entreprise.getZoneGeographique());
            stmt.setString(3, entreprise.getAdresse());
            stmt.setString(4, entreprise.getSecteur());
            stmt.setString(5, entreprise.getDescription());
            stmt.setString(6, entreprise.getTelephone());
            stmt.setString(7, entreprise.getSiteWeb());
            stmt.setInt(8, entreprise.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get enterprise by ID
    public Entreprise getEntrepriseById(int id) {
        String sql = "SELECT * FROM entreprise WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractEntrepriseFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all enterprises
    public List<Entreprise> getAllEntreprises() {
        List<Entreprise> entreprises = new ArrayList<>();
        String sql = "SELECT * FROM entreprise ORDER BY nom";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                entreprises.add(extractEntrepriseFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return entreprises;
    }
    
    // Delete enterprise
    public boolean deleteEntreprise(int id) {
        String sql = "DELETE FROM entreprise WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get offers by enterprise
    public int getOffersCount(int entrepriseId) {
        String sql = "SELECT COUNT(*) FROM offre_stage WHERE entreprise_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, entrepriseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Helper method to extract Entreprise from ResultSet
    private Entreprise extractEntrepriseFromResultSet(ResultSet rs) throws SQLException {
        Entreprise entreprise = new Entreprise();
        entreprise.setId(rs.getInt("id"));
        entreprise.setNom(rs.getString("nom"));
        entreprise.setEmail(rs.getString("email"));
        entreprise.setPassword(rs.getString("password"));
        entreprise.setSpecialites(rs.getString("specialites"));
        entreprise.setZoneGeographique(rs.getString("zone_geographique"));
        entreprise.setAdresse(rs.getString("adresse"));
        entreprise.setSecteur(rs.getString("secteur"));
        entreprise.setDescription(rs.getString("description"));
        entreprise.setTelephone(rs.getString("telephone"));
        entreprise.setSiteWeb(rs.getString("site_web"));
        entreprise.setProfileCompleted(rs.getBoolean("profile_completed"));
        entreprise.setCreatedAt(rs.getTimestamp("created_at"));
        return entreprise;
    }
}
