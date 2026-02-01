package com.stages.servlet;

import com.stages.dao.UserDAO;
import com.stages.dao.EntrepriseDAO;
import com.stages.model.User;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-users")
public class AdminUsersServlet extends HttpServlet {
    private UserDAO userDAO;
    private EntrepriseDAO entrepriseDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        entrepriseDAO = new EntrepriseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get all students and enterprises
        List<User> students = userDAO.getAllUsers();
        List<Entreprise> entreprises = entrepriseDAO.getAllEntreprises();
        
        request.setAttribute("students", students);
        request.setAttribute("entreprises", entreprises);
        request.getRequestDispatcher("admin-users.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String userType = request.getParameter("userType");
        String userIdStr = request.getParameter("userId");
        
        if (action == null || userType == null || userIdStr == null) {
            response.sendRedirect("admin-users");
            return;
        }
        
        int userId = Integer.parseInt(userIdStr);
        
        if ("delete".equals(action)) {
            boolean success = false;
            if ("student".equals(userType)) {
                success = userDAO.deleteUser(userId);
            } else if ("entreprise".equals(userType)) {
                success = entrepriseDAO.deleteEntreprise(userId);
            }
            
            if (success) {
                session.setAttribute("success", "Utilisateur supprimé avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la suppression");
            }
        }
        
        response.sendRedirect("admin-users");
    }
}
