package com.stages.dao;

import com.stages.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // Authenticate user by ONEFD ID
    public User authenticate(String onefdId, String password) {
        String sql = "SELECT * FROM apprenant WHERE onefd_id = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, onefdId);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Register new user with ONEFD ID
    public boolean register(User user) {
        String sql = "INSERT INTO apprenant (onefd_id, nom, prenom, email, password, profile_completed) VALUES (?, ?, ?, ?, ?, FALSE)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getOnefdId());
            stmt.setString(2, user.getNom());
            stmt.setString(3, user.getPrenom());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPassword());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
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
        String sql = "SELECT COUNT(*) FROM apprenant WHERE email = ?";
        
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
    
    // Check if ONEFD ID exists
    public boolean onefdIdExists(String onefdId) {
        String sql = "SELECT COUNT(*) FROM apprenant WHERE onefd_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, onefdId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get user by ONEFD ID
    public User getUserByOnefdId(String onefdId) {
        String sql = "SELECT * FROM apprenant WHERE onefd_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, onefdId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update user profile
    public boolean updateProfile(User user) {
        String sql = "UPDATE apprenant SET specialite = ?, type_stage = ?, " +
                    "zone_geographique = ?, telephone = ?, profile_completed = TRUE " +
                    "WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getSpecialite());
            stmt.setString(2, user.getTypeStage());
            stmt.setString(3, user.getZoneGeographique());
            stmt.setString(4, user.getTelephone());
            stmt.setInt(5, user.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get user by ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM apprenant WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Admin authentication
    public boolean authenticateAdmin(String username, String password) {
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM apprenant ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Delete user
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM apprenant WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get total users count
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM apprenant";
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
    
    // Helper method to extract User from ResultSet
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setOnefdId(rs.getString("onefd_id"));
        user.setNom(rs.getString("nom"));
        user.setPrenom(rs.getString("prenom"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setSpecialite(rs.getString("specialite"));
        user.setTypeStage(rs.getString("type_stage"));
        user.setZoneGeographique(rs.getString("zone_geographique"));
        user.setTelephone(rs.getString("telephone"));
        user.setProfileCompleted(rs.getBoolean("profile_completed"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
