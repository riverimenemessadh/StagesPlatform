package com.stages.servlet;

import com.stages.dao.OffreStageDAO;
import com.stages.model.OffreStage;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/entreprise-offres")
public class EntrepriseOffresServlet extends HttpServlet {
    private OffreStageDAO offreStageDAO;
    
    @Override
    public void init() {
        offreStageDAO = new OffreStageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
        
        // Get all offers for this entreprise
        List<OffreStage> offres = offreStageDAO.getOffresByEntreprise(entreprise.getId());
        
        request.setAttribute("offres", offres);
        request.getRequestDispatcher("entreprise-offres.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            // Edit existing offer
            String offreIdStr = request.getParameter("offreId");
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String specialite = request.getParameter("specialite");
            String typeStage = request.getParameter("typeStage");
            String zone = request.getParameter("zone");
            String dureeMoisStr = request.getParameter("dureeMois");
            String remuneration = request.getParameter("remuneration");
            String competences = request.getParameter("competences");
            
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                int offreId = Integer.parseInt(offreIdStr);
                
                OffreStage offre = offreStageDAO.getOffreById(offreId);
                if (offre != null && offre.getEntrepriseId() == entreprise.getId()) {
                    offre.setTitre(titre);
                    offre.setDescription(description);
                    offre.setSpecialite(specialite);
                    offre.setTypeStage(typeStage);
                    offre.setZoneGeographique(zone);
                    offre.setDureeMois(Integer.parseInt(dureeMoisStr));
                    offre.setRemuneration(remuneration);
                    offre.setCompetencesRequises(competences);
                    
                    if (offreStageDAO.updateOffre(offre)) {
                        session.setAttribute("success", "Offre modifiée avec succès !");
                    } else {
                        session.setAttribute("error", "Erreur lors de la modification de l'offre");
                    }
                }
            }
        } else if ("create".equals(action)) {
            // Create new offer
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String specialite = request.getParameter("specialite");
            String typeStage = request.getParameter("typeStage");
            String zone = request.getParameter("zone");
            String dureeMoisStr = request.getParameter("dureeMois");
            String remuneration = request.getParameter("remuneration");
            String competences = request.getParameter("competences");
            
            // Validation
            if (titre == null || titre.trim().isEmpty() ||
                specialite == null || specialite.trim().isEmpty() ||
                typeStage == null || typeStage.trim().isEmpty() ||
                zone == null || zone.trim().isEmpty() ||
                dureeMoisStr == null || dureeMoisStr.trim().isEmpty()) {
                session.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                response.sendRedirect("entreprise-offres");
                return;
            }
            
            OffreStage offre = new OffreStage();
            offre.setTitre(titre);
            offre.setDescription(description);
            offre.setEntrepriseId(entreprise.getId());
            offre.setSpecialite(specialite);
            offre.setTypeStage(typeStage);
            offre.setZoneGeographique(zone);
            offre.setDureeMois(Integer.parseInt(dureeMoisStr));
            offre.setRemuneration(remuneration);
            offre.setCompetencesRequises(competences);
            offre.setStatut("active");
            
            // Note: created_at timestamp will be recorded automatically by database
            
            if (offreStageDAO.createOffre(offre)) {
                session.setAttribute("success", "Offre créée avec succès !");
            } else {
                session.setAttribute("error", "Erreur lors de la création de l'offre");
            }
        } else if ("delete".equals(action)) {
            // Delete offer
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null && !offreIdStr.isEmpty()) {
                int offreId = Integer.parseInt(offreIdStr);
                if (offreStageDAO.deleteOffre(offreId)) {
                    session.setAttribute("success", "Offre supprimée avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suppression");
                }
            }
        }
        
        response.sendRedirect("entreprise-offres");
    }
}
