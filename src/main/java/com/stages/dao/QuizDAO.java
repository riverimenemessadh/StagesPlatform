package com.stages.dao;

import com.stages.model.Quiz;
import com.stages.model.QuizQuestion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {
    
    // Create a new quiz
    public int createQuiz(Quiz quiz) {
        String sql = "INSERT INTO quiz (entreprise_id, titre, description, passing_score) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, quiz.getEntrepriseId());
            stmt.setString(2, quiz.getTitre());
            stmt.setString(3, quiz.getDescription());
            stmt.setInt(4, quiz.getPassingScore());
            
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
    
    // Add a question to a quiz
    public boolean addQuestion(QuizQuestion question) {
        String sql = "INSERT INTO quiz_question (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, points, question_order) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, question.getQuizId());
            stmt.setString(2, question.getQuestionText());
            stmt.setString(3, question.getOptionA());
            stmt.setString(4, question.getOptionB());
            stmt.setString(5, question.getOptionC());
            stmt.setString(6, question.getOptionD());
            stmt.setString(7, question.getCorrectAnswer());
            stmt.setInt(8, question.getPoints());
            stmt.setInt(9, question.getQuestionOrder());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get quiz by ID
    public Quiz getQuizById(int id) {
        String sql = "SELECT q.*, e.nom as entreprise_name, " +
                    "(SELECT COUNT(*) FROM quiz_question WHERE quiz_id = q.id) as question_count " +
                    "FROM quiz q " +
                    "LEFT JOIN entreprise e ON q.entreprise_id = e.id " +
                    "WHERE q.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractQuizFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all questions for a quiz
    public List<QuizQuestion> getQuestionsByQuizId(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question WHERE quiz_id = ? ORDER BY question_order, id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quizId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                questions.add(extractQuestionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
    
    // Get all quizzes by enterprise
    public List<Quiz> getQuizzesByEntrepriseId(int entrepriseId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, e.nom as entreprise_name, " +
                    "(SELECT COUNT(*) FROM quiz_question WHERE quiz_id = q.id) as question_count " +
                    "FROM quiz q " +
                    "LEFT JOIN entreprise e ON q.entreprise_id = e.id " +
                    "WHERE q.entreprise_id = ? " +
                    "ORDER BY q.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entrepriseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                quizzes.add(extractQuizFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }
    
    // Delete a quiz (and all its questions via CASCADE)
    public boolean deleteQuiz(int id) {
        String sql = "DELETE FROM quiz WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update quiz
    public boolean updateQuiz(Quiz quiz) {
        String sql = "UPDATE quiz SET titre = ?, description = ?, passing_score = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, quiz.getTitre());
            stmt.setString(2, quiz.getDescription());
            stmt.setInt(3, quiz.getPassingScore());
            stmt.setInt(4, quiz.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Delete a question
    public boolean deleteQuestion(int questionId) {
        String sql = "DELETE FROM quiz_question WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, questionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get question by ID
    public QuizQuestion getQuestionById(int id) {
        String sql = "SELECT * FROM quiz_question WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractQuestionFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Helper method to extract Quiz from ResultSet
    private Quiz extractQuizFromResultSet(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(rs.getInt("id"));
        quiz.setEntrepriseId(rs.getInt("entreprise_id"));
        quiz.setTitre(rs.getString("titre"));
        quiz.setDescription(rs.getString("description"));
        quiz.setPassingScore(rs.getInt("passing_score"));
        quiz.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Optional fields
        try {
            quiz.setEntrepriseName(rs.getString("entreprise_name"));
            quiz.setQuestionCount(rs.getInt("question_count"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
        }
        
        return quiz;
    }
    
    // Helper method to extract QuizQuestion from ResultSet
    private QuizQuestion extractQuestionFromResultSet(ResultSet rs) throws SQLException {
        QuizQuestion question = new QuizQuestion();
        question.setId(rs.getInt("id"));
        question.setQuizId(rs.getInt("quiz_id"));
        question.setQuestionText(rs.getString("question_text"));
        question.setOptionA(rs.getString("option_a"));
        question.setOptionB(rs.getString("option_b"));
        question.setOptionC(rs.getString("option_c"));
        question.setOptionD(rs.getString("option_d"));
        question.setCorrectAnswer(rs.getString("correct_answer"));
        question.setPoints(rs.getInt("points"));
        question.setQuestionOrder(rs.getInt("question_order"));
        return question;
    }
}
