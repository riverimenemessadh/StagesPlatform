package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.model.Candidature;
import com.stages.model.Entreprise;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/entreprise-stagiaires")
public class EntrepriseStagiairesServlet extends HttpServlet {
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
        
        // Get all accepted candidatures (interns)
        List<Candidature> stagiaires = candidatureDAO.getCandidaturesByEntrepriseAndStatut(entreprise.getId(), "Acceptée");
        
        request.setAttribute("stagiaires", stagiaires);
        request.getRequestDispatcher("entreprise-stagiaires.jsp").forward(request, response);
    }
}
