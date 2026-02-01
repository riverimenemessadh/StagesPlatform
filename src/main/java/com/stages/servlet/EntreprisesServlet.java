package com.stages.servlet;

import com.stages.dao.EntrepriseDAO;
import com.stages.dao.OffreStageDAO;
import com.stages.model.Entreprise;
import com.stages.model.OffreStage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/entreprises")
public class EntreprisesServlet extends HttpServlet {
    private EntrepriseDAO entrepriseDAO;
    private OffreStageDAO offreDAO;
    
    @Override
    public void init() {
        entrepriseDAO = new EntrepriseDAO();
        offreDAO = new OffreStageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in (student or admin)
        if (session == null || (session.getAttribute("user") == null && session.getAttribute("admin") == null)) {
            response.sendRedirect("login");
            return;
        }
        
        // Check if viewing a specific entreprise
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            // Show specific entreprise detail with their offers
            try {
                int entrepriseId = Integer.parseInt(idParam);
                Entreprise entreprise = entrepriseDAO.getEntrepriseById(entrepriseId);
                List<OffreStage> offres = offreDAO.getOffresByEntreprise(entrepriseId);
                
                if (entreprise != null) {
                    request.setAttribute("entreprise", entreprise);
                    request.setAttribute("offres", offres);
                    request.getRequestDispatcher("entreprise-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("entreprises");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("entreprises");
            }
        } else {
            // Show all entreprises
            List<Entreprise> entreprises = entrepriseDAO.getAllEntreprises();
            request.setAttribute("entreprises", entreprises);
            request.getRequestDispatcher("entreprises.jsp").forward(request, response);
        }
    }
}
