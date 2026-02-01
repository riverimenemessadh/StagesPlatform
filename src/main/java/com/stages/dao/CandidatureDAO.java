package com.stages.dao;

import com.stages.model.Candidature;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidatureDAO {
    
    // Create new application
    public boolean createCandidature(Candidature candidature) {
        String sql = "INSERT INTO candidature (apprenant_id, offre_id, lettre_motivation, statut) " +
                    "VALUES (?, ?, ?, 'En attente')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, candidature.getApprenantId());
            stmt.setInt(2, candidature.getOffreId());
            stmt.setString(3, candidature.getLettreMotivation());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Check if student already applied
    public boolean hasApplied(int apprenantId, int offreId) {
        String sql = "SELECT COUNT(*) FROM candidature WHERE apprenant_id = ? AND offre_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, apprenantId);
            stmt.setInt(2, offreId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get all applications for a student
    public List<Candidature> getCandidaturesByApprenant(int apprenantId) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, o.titre as offre_titre, " +
                    "e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE c.apprenant_id = ? " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, apprenantId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                candidatures.add(extractCandidatureFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Get all applications (for admin)
    public List<Candidature> getAllCandidatures() {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Filter applications by status
    public List<Candidature> getCandidaturesByStatut(String statut) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE c.statut = ? " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, statut);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Update application status
    public boolean updateStatut(int candidatureId, String statut, String commentaire) {
        String sql = "UPDATE candidature SET statut = ?, commentaire_admin = ?, date_reponse = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, statut);
            stmt.setString(2, commentaire);
            stmt.setInt(3, candidatureId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get candidatures with search
    public List<Candidature> searchCandidatures(String searchTerm) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE a.nom LIKE ? OR a.prenom LIKE ? OR a.email LIKE ? OR o.titre LIKE ? OR e.nom LIKE ? " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            stmt.setString(5, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Get recent candidatures (limited number)
    public List<Candidature> getRecentCandidatures(int limit) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "ORDER BY c.date_candidature DESC LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Get candidatures by entreprise
    public List<Candidature> getCandidaturesByEntreprise(int entrepriseId) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE o.entreprise_id = ? " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entrepriseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Get candidatures by entreprise and status
    public List<Candidature> getCandidaturesByEntrepriseAndStatut(int entrepriseId, String statut) {
        List<Candidature> candidatures = new ArrayList<>();
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE o.entreprise_id = ? AND c.statut = ? " +
                    "ORDER BY c.date_candidature DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entrepriseId);
            stmt.setString(2, statut);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                candidatures.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidatures;
    }
    
    // Get candidature by ID (with full details)
    public Candidature getCandidatureById(int id) {
        String sql = "SELECT c.*, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, a.email as apprenant_email, " +
                    "o.titre as offre_titre, e.nom as entreprise_name " +
                    "FROM candidature c " +
                    "JOIN apprenant a ON c.apprenant_id = a.id " +
                    "JOIN offre_stage o ON c.offre_id = o.id " +
                    "JOIN entreprise e ON o.entreprise_id = e.id " +
                    "WHERE c.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Candidature c = extractCandidatureFromResultSet(rs);
                c.setApprenantNom(rs.getString("apprenant_nom"));
                c.setApprenantPrenom(rs.getString("apprenant_prenom"));
                c.setApprenantEmail(rs.getString("apprenant_email"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get statistics
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM candidature";
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
    
    public int getCountByStatut(String statut) {
        String sql = "SELECT COUNT(*) FROM candidature WHERE statut = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, statut);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Helper method
    private Candidature extractCandidatureFromResultSet(ResultSet rs) throws SQLException {
        Candidature c = new Candidature();
        c.setId(rs.getInt("id"));
        c.setApprenantId(rs.getInt("apprenant_id"));
        c.setOffreId(rs.getInt("offre_id"));
        c.setStatut(rs.getString("statut"));
        c.setDateCandidature(rs.getTimestamp("date_candidature"));
        c.setLettreMotivation(rs.getString("lettre_motivation"));
        c.setDateReponse(rs.getTimestamp("date_reponse"));
        c.setCommentaireAdmin(rs.getString("commentaire_admin"));
        c.setOffreTitre(rs.getString("offre_titre"));
        c.setEntrepriseName(rs.getString("entreprise_name"));
        return c;
    }
}