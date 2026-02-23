package com.stages.model;

public class QuizResponse {
    private int id;
    private int attemptId;
    private int questionId;
    private String selectedAnswer;
    private boolean isCorrect;
    private int pointsEarned;
    
    // Additional fields for display
    private String questionText;
    private String correctAnswer;
    private int questionPoints;
    
    // Constructors
    public QuizResponse() {}
    
    public QuizResponse(int attemptId, int questionId, String selectedAnswer) {
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.selectedAnswer = selectedAnswer;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    
    public String getSelectedAnswer() { return selectedAnswer; }
    public void setSelectedAnswer(String selectedAnswer) { this.selectedAnswer = selectedAnswer; }
    
    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }
    
    public int getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(int pointsEarned) { this.pointsEarned = pointsEarned; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    
    public int getQuestionPoints() { return questionPoints; }
    public void setQuestionPoints(int questionPoints) { this.questionPoints = questionPoints; }
}
