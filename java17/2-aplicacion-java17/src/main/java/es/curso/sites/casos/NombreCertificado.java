package es.curso.sites.casos;

import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;

// ARREGLO: el nombre distinguido se interpreta con la API publica de JNDI
// (LdapName). Para leer certificados enteros: java.security.cert.X509Certificate.
public class NombreCertificado {

    public String nombreComun(String dn) throws Exception {
        for (Rdn parte : new LdapName(dn).getRdns()) {
            if ("CN".equalsIgnoreCase(parte.getType())) {
                return parte.getValue().toString();
            }
        }
        return null;
    }
}
