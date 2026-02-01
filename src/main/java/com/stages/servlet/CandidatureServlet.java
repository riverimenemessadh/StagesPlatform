package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.dao.OffreStageDAO;
import com.stages.model.Candidature;
import com.stages.model.OffreStage;
import com.stages.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/candidature")
public class CandidatureServlet extends HttpServlet {
    private CandidatureDAO candidatureDAO;
    private OffreStageDAO offreDAO;
    
    @Override
    public void init() {
        candidatureDAO = new CandidatureDAO();
        offreDAO = new OffreStageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if ("apply".equals(action)) {
            // Show application form
            String offreIdStr = request.getParameter("offreId");
            if (offreIdStr != null) {
                int offreId = Integer.parseInt(offreIdStr);
                
                // Check if already applied
                if (candidatureDAO.hasApplied(user.getId(), offreId)) {
                    session.setAttribute("error", "Vous avez déjà postulé à cette offre");
                    response.sendRedirect("offres");
                    return;
                }
                
                OffreStage offre = offreDAO.getOffreById(offreId);
                request.setAttribute("offre", offre);
                request.getRequestDispatcher("apply.jsp").forward(request, response);
            }
        } else {
            // Show all applications
            List<Candidature> candidatures = candidatureDAO.getCandidaturesByApprenant(user.getId());
            request.setAttribute("candidatures", candidatures);
            request.getRequestDispatcher("mes-candidatures.jsp").forward(request, response);
        }
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
        
        String offreIdStr = request.getParameter("offreId");
        String lettreMotivation = request.getParameter("lettreMotivation");
        
        if (offreIdStr == null || offreIdStr.isEmpty()) {
            response.sendRedirect("offres");
            return;
        }
        
        int offreId = Integer.parseInt(offreIdStr);
        
        // Check if already applied
        if (candidatureDAO.hasApplied(user.getId(), offreId)) {
            session.setAttribute("error", "Vous avez déjà postulé à cette offre");
            response.sendRedirect("offres");
            return;
        }
        
        Candidature candidature = new Candidature(user.getId(), offreId);
        candidature.setLettreMotivation(lettreMotivation);
        
        if (candidatureDAO.createCandidature(candidature)) {
            session.setAttribute("success", "Votre candidature a été enregistrée avec succès !");
            response.sendRedirect("candidature");
        } else {
            session.setAttribute("error", "Erreur lors de l'envoi de la candidature");
            response.sendRedirect("offres");
        }
    }
}
