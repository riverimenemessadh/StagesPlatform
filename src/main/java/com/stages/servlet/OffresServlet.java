package com.stages.servlet;

import com.stages.dao.OffreStageDAO;
import com.stages.model.OffreStage;
import com.stages.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/offres")
public class OffresServlet extends HttpServlet {
    private OffreStageDAO offreDAO;
    
    @Override
    public void init() {
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
        
        // Check if profile is completed
        if (!user.isProfileCompleted()) {
            response.sendRedirect("profile");
            return;
        }
        
        // Get filter parameters
        String specialite = request.getParameter("specialite");
        String zone = request.getParameter("zone");
        String type = request.getParameter("type");
        
        List<OffreStage> offres;
        
        // Apply filters if present
        if ((specialite != null && !specialite.isEmpty()) ||
            (zone != null && !zone.isEmpty()) ||
            (type != null && !type.isEmpty())) {
            offres = offreDAO.searchOffres(specialite, zone, type);
        } else {
            offres = offreDAO.getAllOffres();
        }
        
        // Get distinct values for filters
        List<String> specialites = offreDAO.getDistinctSpecialites();
        List<String> zones = offreDAO.getDistinctZones();
        
        request.setAttribute("offres", offres);
        request.setAttribute("specialites", specialites);
        request.setAttribute("zones", zones);
        request.setAttribute("selectedSpecialite", specialite);
        request.setAttribute("selectedZone", zone);
        request.setAttribute("selectedType", type);
        
        request.getRequestDispatcher("offres.jsp").forward(request, response);
    }
}
