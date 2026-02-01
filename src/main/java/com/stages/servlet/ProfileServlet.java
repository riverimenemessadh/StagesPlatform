package com.stages.servlet;

import com.stages.dao.UserDAO;
import com.stages.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        String specialite = request.getParameter("specialite");
        String typeStage = request.getParameter("typeStage");
        String zone = request.getParameter("zone");
        String telephone = request.getParameter("telephone");
        
        // Validation
        if (specialite == null || specialite.trim().isEmpty() ||
            typeStage == null || typeStage.trim().isEmpty() ||
            zone == null || zone.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        user.setSpecialite(specialite);
        user.setTypeStage(typeStage);
        user.setZoneGeographique(zone);
        user.setTelephone(telephone);
        
        if (userDAO.updateProfile(user)) {
            user.setProfileCompleted(true);
            session.setAttribute("user", user);
            session.setAttribute("success", "Profil mis à jour avec succès !");
            response.sendRedirect("offres");
        } else {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
