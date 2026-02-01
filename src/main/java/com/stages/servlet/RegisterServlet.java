package com.stages.servlet;

import com.stages.dao.UserDAO;
import com.stages.dao.EntrepriseDAO;
import com.stages.model.User;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
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
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (userType == null) {
            userType = "student";
        }
        
        // Common validation
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs sont obligatoires");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if ("entreprise".equals(userType)) {
            // Enterprise registration
            String nomEntreprise = request.getParameter("nomEntreprise");
            
            if (nomEntreprise == null || nomEntreprise.trim().isEmpty()) {
                request.setAttribute("error", "Tous les champs sont obligatoires");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (entrepriseDAO.emailExists(email)) {
                request.setAttribute("error", "Cet email est déjà utilisé");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create entreprise
            Entreprise entreprise = new Entreprise(nomEntreprise, email, password);
            
            if (entrepriseDAO.register(entreprise)) {
                HttpSession session = request.getSession();
                session.setAttribute("entreprise", entreprise);
                session.setAttribute("success", "Inscription réussie ! Veuillez compléter votre profil");
                response.sendRedirect("entreprise-profile");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } else {
            // Student registration
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            
            if (nom == null || nom.trim().isEmpty() ||
                prenom == null || prenom.trim().isEmpty()) {
                request.setAttribute("error", "Tous les champs sont obligatoires");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "Cet email est déjà utilisé");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create user
            User user = new User(nom, prenom, email, password);
            
            if (userDAO.register(user)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("success", "Inscription réussie ! Veuillez compléter votre profil");
                response.sendRedirect("profile");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }
}
