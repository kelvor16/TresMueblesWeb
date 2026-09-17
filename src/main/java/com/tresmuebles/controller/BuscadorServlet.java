package com.tresmuebles.controller;

import com.tresmuebles.dao.CatalogoDAO;
import com.tresmuebles.dao.PropiedadDAO;
import com.tresmuebles.model.Propiedad;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/buscador")
public class BuscadorServlet extends HttpServlet {
    
    private PropiedadDAO propiedadDAO;
    private CatalogoDAO catalogoDAO;

    @Override
    public void init() {
        propiedadDAO = new PropiedadDAO();
        catalogoDAO = new CatalogoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Siempre cargar los catálogos para los filtros
        request.setAttribute("ciudades", catalogoDAO.obtenerCiudades());
        request.setAttribute("tipos", catalogoDAO.obtenerTiposPropiedad());

        if ("detalle".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Propiedad p = propiedadDAO.obtenerPropiedad(id);
            if (p != null) {
                request.setAttribute("propiedad", p);
                request.getRequestDispatcher("/detalle-propiedad.jsp").forward(request, response);
            } else {
                response.sendRedirect("buscador");
            }
        } else {
            // Lógica de búsqueda
            Integer idCiudad = null;
            Integer idTipo = null;
            Double precioMin = null;
            Double precioMax = null;

            try {
                if (request.getParameter("ciudad") != null && !request.getParameter("ciudad").isEmpty()) {
                    idCiudad = Integer.parseInt(request.getParameter("ciudad"));
                }
                if (request.getParameter("tipo") != null && !request.getParameter("tipo").isEmpty()) {
                    idTipo = Integer.parseInt(request.getParameter("tipo"));
                }
                if (request.getParameter("precioMin") != null && !request.getParameter("precioMin").isEmpty()) {
                    precioMin = Double.parseDouble(request.getParameter("precioMin"));
                }
                if (request.getParameter("precioMax") != null && !request.getParameter("precioMax").isEmpty()) {
                    precioMax = Double.parseDouble(request.getParameter("precioMax"));
                }
            } catch (NumberFormatException e) {
                // Ignorar filtros inválidos
            }

            List<Propiedad> resultados = propiedadDAO.buscarPropiedades(idCiudad, idTipo, precioMin, precioMax);
            request.setAttribute("propiedades", resultados);
            
            request.getRequestDispatcher("/buscador.jsp").forward(request, response);
        }
    }
}
