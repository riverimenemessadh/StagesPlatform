package com.stages.dao;

import com.stages.model.QuizAttempt;
import com.stages.model.QuizResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizAttemptDAO {
    
    // Create a new quiz attempt
    public int createAttempt(QuizAttempt attempt) {
        String sql = "INSERT INTO quiz_attempt (quiz_id, apprenant_id, offre_id, score, total_points, earned_points, passed) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, attempt.getQuizId());
            stmt.setInt(2, attempt.getApprenantId());
            stmt.setInt(3, attempt.getOffreId());
            stmt.setDouble(4, attempt.getScore());
            stmt.setInt(5, attempt.getTotalPoints());
            stmt.setInt(6, attempt.getEarnedPoints());
            stmt.setBoolean(7, attempt.isPassed());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Save a quiz response
    public boolean saveResponse(QuizResponse response) {
        String sql = "INSERT INTO quiz_response (attempt_id, question_id, selected_answer, is_correct, points_earned) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, response.getAttemptId());
            stmt.setInt(2, response.getQuestionId());
            stmt.setString(3, response.getSelectedAnswer());
            stmt.setBoolean(4, response.isCorrect());
            stmt.setInt(5, response.getPointsEarned());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Calculate and update the final score for an attempt
    public boolean calculateScore(int attemptId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Get quiz passing score
            String getPassingScoreSql = "SELECT q.passing_score FROM quiz_attempt qa " +
                                       "JOIN quiz q ON qa.quiz_id = q.id WHERE qa.id = ?";
            int passingScore = 75; // Default
            
            try (PreparedStatement stmt = conn.prepareStatement(getPassingScoreSql)) {
                stmt.setInt(1, attemptId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    passingScore = rs.getInt("passing_score");
                }
            }
            
            // Calculate total and earned points
            String calculateSql = "SELECT " +
                                "SUM(qr.points_earned) as earned, " +
                                "SUM(qq.points) as total " +
                                "FROM quiz_response qr " +
                                "JOIN quiz_question qq ON qr.question_id = qq.id " +
                                "WHERE qr.attempt_id = ?";
            
            int earnedPoints = 0;
            int totalPoints = 0;
            
            try (PreparedStatement stmt = conn.prepareStatement(calculateSql)) {
                stmt.setInt(1, attemptId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    earnedPoints = rs.getInt("earned");
                    totalPoints = rs.getInt("total");
                }
            }
            
            // Calculate percentage score
            double score = totalPoints > 0 ? (earnedPoints * 100.0) / totalPoints : 0;
            boolean passed = score >= passingScore;
            
            // Update the attempt
            String updateSql = "UPDATE quiz_attempt SET score = ?, total_points = ?, earned_points = ?, passed = ? WHERE id = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setDouble(1, score);
                stmt.setInt(2, totalPoints);
                stmt.setInt(3, earnedPoints);
                stmt.setBoolean(4, passed);
                stmt.setInt(5, attemptId);
                
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get attempt by ID
    public QuizAttempt getAttemptById(int id) {
        String sql = "SELECT qa.*, q.titre as quiz_titre, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, " +
                    "o.titre as offre_titre " +
                    "FROM quiz_attempt qa " +
                    "LEFT JOIN quiz q ON qa.quiz_id = q.id " +
                    "LEFT JOIN apprenant a ON qa.apprenant_id = a.id " +
                    "LEFT JOIN offre_stage o ON qa.offre_id = o.id " +
                    "WHERE qa.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAttemptFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all responses for an attempt
    public List<QuizResponse> getResponsesByAttemptId(int attemptId) {
        List<QuizResponse> responses = new ArrayList<>();
        String sql = "SELECT qr.*, qq.question_text, qq.correct_answer, qq.points as question_points " +
                    "FROM quiz_response qr " +
                    "JOIN quiz_question qq ON qr.question_id = qq.id " +
                    "WHERE qr.attempt_id = ? " +
                    "ORDER BY qq.question_order, qq.id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, attemptId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                responses.add(extractResponseFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return responses;
    }
    
    // Check if student has completed quiz for a specific offer
    public boolean hasCompletedQuiz(int apprenantId, int quizId, int offreId) {
        String sql = "SELECT COUNT(*) FROM quiz_attempt WHERE apprenant_id = ? AND quiz_id = ? AND offre_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, apprenantId);
            stmt.setInt(2, quizId);
            stmt.setInt(3, offreId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get attempt by student and offer
    public QuizAttempt getAttemptByStudentAndOffer(int apprenantId, int offreId) {
        String sql = "SELECT qa.*, q.titre as quiz_titre, " +
                    "a.nom as apprenant_nom, a.prenom as apprenant_prenom, " +
                    "o.titre as offre_titre " +
                    "FROM quiz_attempt qa " +
                    "LEFT JOIN quiz q ON qa.quiz_id = q.id " +
                    "LEFT JOIN apprenant a ON qa.apprenant_id = a.id " +
                    "LEFT JOIN offre_stage o ON qa.offre_id = o.id " +
                    "WHERE qa.apprenant_id = ? AND qa.offre_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, apprenantId);
            stmt.setInt(2, offreId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAttemptFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Helper method to extract QuizAttempt from ResultSet
    private QuizAttempt extractAttemptFromResultSet(ResultSet rs) throws SQLException {
        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(rs.getInt("id"));
        attempt.setQuizId(rs.getInt("quiz_id"));
        attempt.setApprenantId(rs.getInt("apprenant_id"));
        attempt.setOffreId(rs.getInt("offre_id"));
        attempt.setScore(rs.getDouble("score"));
        attempt.setTotalPoints(rs.getInt("total_points"));
        attempt.setEarnedPoints(rs.getInt("earned_points"));
        attempt.setPassed(rs.getBoolean("passed"));
        attempt.setCompletedAt(rs.getTimestamp("completed_at"));
        
        // Optional fields
        try {
            attempt.setQuizTitre(rs.getString("quiz_titre"));
            attempt.setApprenantNom(rs.getString("apprenant_nom"));
            attempt.setApprenantPrenom(rs.getString("apprenant_prenom"));
            attempt.setOffreTitre(rs.getString("offre_titre"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
        }
        
        return attempt;
    }
    
    // Helper method to extract QuizResponse from ResultSet
    private QuizResponse extractResponseFromResultSet(ResultSet rs) throws SQLException {
        QuizResponse response = new QuizResponse();
        response.setId(rs.getInt("id"));
        response.setAttemptId(rs.getInt("attempt_id"));
        response.setQuestionId(rs.getInt("question_id"));
        response.setSelectedAnswer(rs.getString("selected_answer"));
        response.setCorrect(rs.getBoolean("is_correct"));
        response.setPointsEarned(rs.getInt("points_earned"));
        
        // Optional fields
        try {
            response.setQuestionText(rs.getString("question_text"));
            response.setCorrectAnswer(rs.getString("correct_answer"));
            response.setQuestionPoints(rs.getInt("question_points"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
        }
        
        return response;
    }
}
