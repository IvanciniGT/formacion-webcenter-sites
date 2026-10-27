package es.curso.sites.web;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

// Un filtro normal y corriente, escrito para javax.servlet, que es lo que hay
// en WebLogic 14.1.2. Con Spring 5.3 encaja; con Spring 6, OncePerRequestFilter
// espera jakarta.servlet y esta clase deja de compilar.
public class FiltroCabeceras extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest peticion, HttpServletResponse respuesta,
                                    FilterChain cadena) throws ServletException, IOException {
        respuesta.setHeader("X-Curso", "webcenter-sites");
        cadena.doFilter(peticion, respuesta);
    }
}
