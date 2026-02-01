package com.stages.servlet;

import com.stages.dao.EntrepriseDAO;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/entreprise-profile")
public class EntrepriseProfileServlet extends HttpServlet {
    private EntrepriseDAO entrepriseDAO;
    
    @Override
    public void init() {
        entrepriseDAO = new EntrepriseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("entreprise-profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
        
        String zone = request.getParameter("zone");
        String adresse = request.getParameter("adresse");
        String secteur = request.getParameter("secteur");
        String description = request.getParameter("description");
        String telephone = request.getParameter("telephone");
        String siteWeb = request.getParameter("siteWeb");
        
        // Validation
        if (zone == null || zone.trim().isEmpty() || secteur == null || secteur.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            request.getRequestDispatcher("entreprise-profile.jsp").forward(request, response);
            return;
        }
        
        entreprise.setSpecialites(null);
        entreprise.setZoneGeographique(zone);
        entreprise.setAdresse(adresse);
        entreprise.setSecteur(secteur);
        entreprise.setDescription(description);
        entreprise.setTelephone(telephone);
        entreprise.setSiteWeb(siteWeb);
        
        if (entrepriseDAO.updateProfile(entreprise)) {
            entreprise.setProfileCompleted(true);
            session.setAttribute("entreprise", entreprise);
            session.setAttribute("success", "Profil mis à jour avec succès !");
            response.sendRedirect("entreprise-dashboard");
        } else {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil");
            request.getRequestDispatcher("entreprise-profile.jsp").forward(request, response);
        }
    }
}
