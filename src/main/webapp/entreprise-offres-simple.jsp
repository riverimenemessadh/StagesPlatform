<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.stages.model.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Simple Test</title>
</head>
<body>
    <h1>Test Page</h1>
    <%
        try {
            out.println("<p>Step 1: Getting session...</p>");
            Entreprise entreprise = (Entreprise) session.getAttribute("entreprise");
            
            out.println("<p>Step 2: Session retrieved - " + (entreprise != null ? "SUCCESS" : "FAILED - NULL") + "</p>");
            
            if (entreprise != null) {
                out.println("<p>Entreprise: " + entreprise.getNom() + "</p>");
            }
            
            out.println("<p>Step 3: Getting offres from request...</p>");
            List<OffreStage> offres = (List<OffreStage>) request.getAttribute("offres");
            
            out.println("<p>Step 4: Offres - " + (offres != null ? "Found " + offres.size() + " offers" : "NULL") + "</p>");
            
            if (offres != null && !offres.isEmpty()) {
                out.println("<h2>Offers:</h2>");
                for (OffreStage offre : offres) {
                    out.println("<div style='border:1px solid #ccc; padding:10px; margin:10px;'>");
                    out.println("<p>ID: " + offre.getId() + "</p>");
                    out.println("<p>Title: " + offre.getTitre() + "</p>");
                    out.println("<p>Has Quiz: " + offre.hasQuiz() + "</p>");
                    out.println("</div>");
                }
            }
            
            out.println("<p style='color:green;'>SUCCESS - Page loaded completely!</p>");
            
        } catch (Exception e) {
            out.println("<h2 style='color:red;'>ERROR:</h2>");
            out.println("<pre style='background:#fee; padding:20px;'>");
            out.println("Message: " + e.getMessage());
            out.println("\nStack Trace:\n");
            java.io.StringWriter sw = new java.io.StringWriter();
            e.printStackTrace(new java.io.PrintWriter(sw));
            out.println(sw.toString());
            out.println("</pre>");
        }
    %>
</body>
</html>
