package com.tresmuebles.filter;

import com.tresmuebles.model.Usuario;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/panel/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
            
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        boolean loggedIn = session != null && session.getAttribute("usuarioLogueado") != null;
        
        if (loggedIn) {
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
            String requestURI = req.getRequestURI();
            
            if (requestURI.startsWith(req.getContextPath() + "/panel/admin") && !usuario.hasRol("Administrador")) {
                res.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp?error=rol");
                return;
            }
            if (requestURI.startsWith(req.getContextPath() + "/panel/agente") && !usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador")) {
                res.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp?error=rol");
                return;
            }
            if (requestURI.startsWith(req.getContextPath() + "/panel/cliente") && !usuario.hasRol("Cliente") && !usuario.hasRol("Administrador")) {
                res.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp?error=rol");
                return;
            }
            
            chain.doFilter(request, response);
        } else {
            // Usuario no autenticado intentando entrar a /panel/*
            res.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp?error=no_sesion");
        }
    }

    @Override
    public void destroy() {
        // Limpieza
    }
}
