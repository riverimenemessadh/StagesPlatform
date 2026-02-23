package com.stages.servlet;

import com.stages.dao.UserDAO;
import com.stages.dao.EntrepriseDAO;
import com.stages.model.User;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
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
        // If already logged in, redirect to appropriate page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("offres");
            return;
        }
        if (session != null && session.getAttribute("entreprise") != null) {
            response.sendRedirect("entreprise-dashboard");
            return;
        }
        if (session != null && session.getAttribute("admin") != null) {
            response.sendRedirect("admin");
            return;
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");  // ONEFD ID for student, email for others
        String password = request.getParameter("password");
        String userType = request.getParameter("userType"); // "student", "entreprise" or "admin"
        
        if (userType == null) {
            userType = "student";
        }
        
        if ("admin".equals(userType)) {
            // Admin login (uses email/username)
            boolean isAdmin = userDAO.authenticateAdmin(identifier, password);
            
            if (isAdmin) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", identifier);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                response.sendRedirect("admin");
            } else {
                request.setAttribute("error", "Identifiants administrateur invalides");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("entreprise".equals(userType)) {
            // Enterprise login (uses email)
            Entreprise entreprise = entrepriseDAO.authenticate(identifier, password);
            
            if (entreprise != null) {
                HttpSession session = request.getSession();
                session.setAttribute("entreprise", entreprise);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to profile if not completed, otherwise to dashboard
                if (!entreprise.isProfileCompleted()) {
                    response.sendRedirect("entreprise-profile");
                } else {
                    response.sendRedirect("entreprise-dashboard");
                }
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            // Student login (uses ONEFD ID)
            User user = userDAO.authenticate(identifier, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to profile if not completed, otherwise to offers
                if (!user.isProfileCompleted()) {
                    response.sendRedirect("profile");
                } else {
                    response.sendRedirect("offres");
                }
            } else {
                request.setAttribute("error", "Identifiant ONEFD ou mot de passe incorrect");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}

