package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.model.Candidature;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/entreprise-dashboard")
public class EntrepriseDashboardServlet extends HttpServlet {
    private CandidatureDAO candidatureDAO;
    
    @Override
    public void init() {
        candidatureDAO = new CandidatureDAO();
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
        String statutFilter = request.getParameter("statut");
        
        List<Candidature> candidatures;
        
        if (statutFilter != null && !statutFilter.isEmpty() && !"all".equals(statutFilter)) {
            candidatures = candidatureDAO.getCandidaturesByEntrepriseAndStatut(entreprise.getId(), statutFilter);
        } else {
            candidatures = candidatureDAO.getCandidaturesByEntreprise(entreprise.getId());
        }
        
        request.setAttribute("candidatures", candidatures);
        request.setAttribute("selectedStatut", statutFilter);
        request.getRequestDispatcher("entreprise-dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("entreprise") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String candidatureIdStr = request.getParameter("candidatureId");
        
        if (candidatureIdStr == null || candidatureIdStr.isEmpty()) {
            response.sendRedirect("entreprise-dashboard");
            return;
        }
        
        int candidatureId = Integer.parseInt(candidatureIdStr);
        String commentaire = request.getParameter("commentaire");
        
        String newStatut = null;
        if ("accept".equals(action)) {
            newStatut = "Acceptée";
        } else if ("reject".equals(action)) {
            newStatut = "Refusée";
        }
        
        if (newStatut != null) {
            if (candidatureDAO.updateStatut(candidatureId, newStatut, commentaire)) {
                session.setAttribute("success", "Candidature mise à jour avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la mise à jour");
            }
        }
        
        response.sendRedirect("entreprise-dashboard");
    }
}
