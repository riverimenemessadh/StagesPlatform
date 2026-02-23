package com.stages;

import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        String port = System.getenv("PORT");
        if (port == null) port = "8080";

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(port));
        tomcat.getConnector();

        String webappDir = new File("src/main/webapp").getAbsolutePath();
        tomcat.addWebapp("", webappDir);

        tomcat.start();
        tomcat.getServer().await();
    }
}