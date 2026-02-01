package com.stages.servlet;

import com.stages.dao.EntrepriseDAO;
import com.stages.dao.OffreStageDAO;
import com.stages.model.Entreprise;
import com.stages.model.OffreStage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin-offres")
public class AdminOffresServlet extends HttpServlet {
    private EntrepriseDAO entrepriseDAO;
    private OffreStageDAO offreStageDAO;
    
    @Override
    public void init() {
        entrepriseDAO = new EntrepriseDAO();
        offreStageDAO = new OffreStageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get entreprise details if requested
        String entrepriseIdStr = request.getParameter("entrepriseId");
        Entreprise selectedEntreprise = null;
        List<OffreStage> offres = null;
        
        if (entrepriseIdStr != null && !entrepriseIdStr.isEmpty()) {
            int entrepriseId = Integer.parseInt(entrepriseIdStr);
            selectedEntreprise = entrepriseDAO.getEntrepriseById(entrepriseId);
            offres = offreStageDAO.getOffresByEntreprise(entrepriseId);
        }
        
        // Get all enterprises
        List<Entreprise> entreprises = entrepriseDAO.getAllEntreprises();
        
        request.setAttribute("entreprises", entreprises);
        request.setAttribute("selectedEntreprise", selectedEntreprise);
        request.setAttribute("offres", offres);
        request.getRequestDispatcher("admin-offres.jsp").forward(request, response);
    }
}
