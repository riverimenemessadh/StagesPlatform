package com.stages.servlet;

import com.stages.dao.CandidatureDAO;
import com.stages.model.Candidature;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin-candidatures")
public class AdminCandidaturesServlet extends HttpServlet {
    private CandidatureDAO candidatureDAO;
    
    @Override
    public void init() {
        candidatureDAO = new CandidatureDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String statutFilter = request.getParameter("statut");
        
        List<Candidature> candidatures;
        
        if (statutFilter != null && !statutFilter.isEmpty() && !"all".equals(statutFilter)) {
            candidatures = candidatureDAO.getCandidaturesByStatut(statutFilter);
        } else {
            candidatures = candidatureDAO.getAllCandidatures();
        }
        
        // Group candidatures by student
        Map<Integer, List<Candidature>> candidaturesGrouped = new LinkedHashMap<>();
        Map<Integer, String> studentNames = new HashMap<>();
        
        for (Candidature c : candidatures) {
            int studentId = c.getApprenantId();
            if (!candidaturesGrouped.containsKey(studentId)) {
                candidaturesGrouped.put(studentId, new ArrayList<>());
                studentNames.put(studentId, c.getApprenantFullName() + " (" + c.getApprenantEmail() + ")");
            }
            candidaturesGrouped.get(studentId).add(c);
        }
        
        request.setAttribute("candidaturesGrouped", candidaturesGrouped);
        request.setAttribute("studentNames", studentNames);
        request.setAttribute("selectedStatut", statutFilter);
        request.getRequestDispatcher("admin-candidatures.jsp").forward(request, response);
    }
}
