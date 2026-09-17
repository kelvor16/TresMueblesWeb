package com.tresmuebles.controller;

import com.tresmuebles.dao.CatalogoDAO;
import com.tresmuebles.dao.PropiedadDAO;
import com.tresmuebles.model.Caracteristica;
import com.tresmuebles.model.Ciudad;
import com.tresmuebles.model.ImagenPropiedad;
import com.tresmuebles.model.Propiedad;
import com.tresmuebles.model.TipoPropiedad;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/panel/agente/propiedades")
public class PropiedadServlet extends HttpServlet {
    
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
        HttpSession session = request.getSession(false);
        Usuario agente = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (action == null || "listar".equals(action)) {
            List<Propiedad> lista = propiedadDAO.listarPorAgente(agente.getIdUsuario());
            request.setAttribute("propiedades", lista);
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } else if ("nueva".equals(action)) {
            request.setAttribute("ciudades", catalogoDAO.obtenerCiudades());
            request.setAttribute("tipos", catalogoDAO.obtenerTiposPropiedad());
            request.setAttribute("caracteristicas", catalogoDAO.obtenerCaracteristicas());
            request.getRequestDispatcher("formulario-propiedad.jsp").forward(request, response);
        } else if ("editar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Propiedad p = propiedadDAO.obtenerPropiedad(id);
            if (p != null && p.getAgente().getIdUsuario() == agente.getIdUsuario()) {
                request.setAttribute("propiedad", p);
                request.setAttribute("ciudades", catalogoDAO.obtenerCiudades());
                request.setAttribute("tipos", catalogoDAO.obtenerTiposPropiedad());
                request.setAttribute("caracteristicas", catalogoDAO.obtenerCaracteristicas());
                request.getRequestDispatcher("formulario-propiedad.jsp").forward(request, response);
            } else {
                response.sendRedirect("propiedades?action=listar&error=Propiedad+no+encontrada+o+sin+autorizacion");
            }
        } else if ("cambiarEstado".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");
            propiedadDAO.cambiarEstado(id, estado, agente.getIdUsuario());
            response.sendRedirect("propiedades?action=listar&mensaje=Estado+actualizado");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Usuario agente = (Usuario) session.getAttribute("usuarioLogueado");

        if ("guardar".equals(action)) {
            Propiedad p = new Propiedad();
            p.setMatriculaInmobiliaria(request.getParameter("matricula"));
            p.setTitulo(request.getParameter("titulo"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
            p.setArea(Double.parseDouble(request.getParameter("area")));
            p.setHabitaciones(Integer.parseInt(request.getParameter("habitaciones")));
            p.setBanos(Integer.parseInt(request.getParameter("banos")));
            p.setEstadoPublicacion("disponible");
            p.setAgente(agente);
            
            Ciudad c = new Ciudad();
            c.setIdCiudad(Integer.parseInt(request.getParameter("ciudad")));
            p.setCiudad(c);
            
            TipoPropiedad t = new TipoPropiedad();
            t.setIdTipo(Integer.parseInt(request.getParameter("tipo")));
            p.setTipo(t);
            
            // Características
            String[] caracs = request.getParameterValues("caracteristicas");
            if (caracs != null) {
                List<Caracteristica> clist = new ArrayList<>();
                for (String cId : caracs) {
                    clist.add(new Caracteristica(Integer.parseInt(cId), ""));
                }
                p.setCaracteristicas(clist);
            }
            
            // Imágenes (simulando URLs ingresadas)
            String[] urls = request.getParameterValues("imagenesUrl");
            if (urls != null) {
                List<ImagenPropiedad> imgList = new ArrayList<>();
                for (int i = 0; i < urls.length; i++) {
                    if (!urls[i].trim().isEmpty()) {
                        ImagenPropiedad img = new ImagenPropiedad();
                        img.setUrlImagen(urls[i].trim());
                        img.setEsPrincipal(i == 0); // La primera es principal
                        imgList.add(img);
                    }
                }
                p.setImagenes(imgList);
            }
            
            boolean ok = propiedadDAO.registrarPropiedad(p);
            if (ok) {
                new com.tresmuebles.dao.AuditoriaDAO().registrar(agente.getIdUsuario(), "Creación de propiedad: " + p.getTitulo(), "Inmuebles");
                response.sendRedirect("propiedades?action=listar&mensaje=Propiedad+creada+con+exito");
            } else {
                response.sendRedirect("propiedades?action=nueva&error=Error+al+crear.+Revise+matricula+unica.");
            }
        } else if ("actualizar".equals(action)) {
            Propiedad p = new Propiedad();
            p.setIdPropiedad(Integer.parseInt(request.getParameter("idPropiedad")));
            p.setMatriculaInmobiliaria(request.getParameter("matricula"));
            p.setTitulo(request.getParameter("titulo"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
            p.setArea(Double.parseDouble(request.getParameter("area")));
            p.setHabitaciones(Integer.parseInt(request.getParameter("habitaciones")));
            p.setBanos(Integer.parseInt(request.getParameter("banos")));
            p.setAgente(agente);
            
            Ciudad c = new Ciudad();
            c.setIdCiudad(Integer.parseInt(request.getParameter("ciudad")));
            p.setCiudad(c);
            
            TipoPropiedad t = new TipoPropiedad();
            t.setIdTipo(Integer.parseInt(request.getParameter("tipo")));
            p.setTipo(t);

            boolean ok = propiedadDAO.actualizarPropiedad(p);
            if (ok) {
                new com.tresmuebles.dao.AuditoriaDAO().registrar(agente.getIdUsuario(), "Edición de propiedad ID " + p.getIdPropiedad(), "Inmuebles");
                response.sendRedirect("propiedades?action=listar&mensaje=Propiedad+actualizada+con+exito");
            } else {
                response.sendRedirect("propiedades?action=editar&id=" + p.getIdPropiedad() + "&error=Error+al+actualizar+la+propiedad");
            }
        }
    }
}
