package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.dao.OffreStageDAO;
import com.stages.dao.UserDAO;
import com.stages.dao.EntrepriseDAO;
import com.stages.model.Candidature;
import com.stages.model.OffreStage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private CandidatureDAO candidatureDAO;
    private OffreStageDAO offreStageDAO;
    private UserDAO userDAO;
    private EntrepriseDAO entrepriseDAO;
    
    @Override
    public void init() {
        candidatureDAO = new CandidatureDAO();
        offreStageDAO = new OffreStageDAO();
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
        
        String searchTerm = request.getParameter("search");
        String statutFilter = request.getParameter("statut");
        
        List<Candidature> candidatures;
        
        // Handle search and/or filter
        boolean hasSearch = searchTerm != null && !searchTerm.trim().isEmpty();
        boolean hasFilter = statutFilter != null && !statutFilter.isEmpty() && !"all".equals(statutFilter);
        
        if (hasSearch) {
            // Search first
            candidatures = candidatureDAO.searchCandidatures(searchTerm);
            // Then apply filter if present
            if (hasFilter) {
                List<Candidature> filtered = new ArrayList<>();
                for (Candidature c : candidatures) {
                    if (statutFilter.equals(c.getStatut())) {
                        filtered.add(c);
                    }
                }
                candidatures = filtered;
            }
        } else if (hasFilter) {
            candidatures = candidatureDAO.getCandidaturesByStatut(statutFilter);
        } else {
            // Show only recent 6 candidatures on dashboard
            candidatures = candidatureDAO.getRecentCandidatures(6);
        }
        
        // Get statistics
        int totalStudents = userDAO.getTotalCount();
        int totalEntreprises = entrepriseDAO.getAllEntreprises().size();
        int totalCandidatures = candidatureDAO.getTotalCount();
        int totalOffres = offreStageDAO.getTotalCount();
        
        // Get recent offers
        List<OffreStage> recentOffres = offreStageDAO.getRecentOffres(6);
        
        request.setAttribute("candidatures", candidatures);
        request.setAttribute("recentOffres", recentOffres);
        request.setAttribute("selectedStatut", statutFilter);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalEntreprises", totalEntreprises);
        request.setAttribute("totalCandidatures", totalCandidatures);
        request.setAttribute("totalOffres", totalOffres);
        
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Admin can no longer accept/reject applications
        // This functionality is now only for enterprises
        response.sendRedirect("admin");
    }
}