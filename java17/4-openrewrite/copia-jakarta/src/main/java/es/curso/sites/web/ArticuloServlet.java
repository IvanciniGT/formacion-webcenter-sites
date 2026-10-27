package es.curso.sites.web;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.curso.sites.casos.Articulo;
import es.curso.sites.casos.ConversorXml;

// Para que sea una WAR de verdad, como las que se despliegan junto a Sites.
// javax.servlet NO da problemas: lo trae WebLogic, en 12.2.1.4 y en 14.1.2.
@WebServlet("/articulo")
public class ArticuloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest peticion, HttpServletResponse respuesta) throws IOException {
        respuesta.setContentType("application/xml;charset=UTF-8");
        try {
            respuesta.getWriter().write(new ConversorXml().aXml(new Articulo("Hola", "Mundo")));
        } catch (Exception error) {
            throw new IOException(error);
        }
    }
}
