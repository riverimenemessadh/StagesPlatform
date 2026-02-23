package com.stages;

import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT");
        if (port == null) port = "8080";

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));
        tomcat.getConnector();

        String webappDir = new File("src/main/webapp").getAbsolutePath();
        var ctx = tomcat.addWebapp("", webappDir);

        WebResourceRoot resources = new StandardRoot(ctx);
        resources.addPreResources(new DirResourceSet(
            resources,
            "/WEB-INF/classes",
            new File("target/classes").getAbsolutePath(),
            "/"
        ));
        ctx.setResources(resources);

        tomcat.start();
        tomcat.getServer().await();
    }
}