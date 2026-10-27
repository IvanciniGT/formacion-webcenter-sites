package es.curso.sites.casos;

import sun.security.x509.X500Name;

// CASO: API interna de seguridad. Tipico en codigo que lee certificados para
// integraciones (SSO, firma). En Java 17 el paquete no se exporta.
public class NombreCertificado {

    public String nombreComun(String dn) throws Exception {
        return new X500Name(dn).getCommonName();
    }
}
