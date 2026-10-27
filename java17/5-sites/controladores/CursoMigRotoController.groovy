package oracle.webcenter.sites.controller

import com.fatwire.assetapi.data.*

// «Lo de sun http», en un controlador. Groovy lo compila, porque la clase existe
// en el JDK 17; lo que Java 17 ya no deja es usarla desde fuera del JDK. Asi que
// revienta al pedir la pagina, no al guardar el controlador.
public class CursoMigRotoController extends BaseController
{
	public void doWork(Map models)
	{
		def conexion = new sun.net.www.protocol.http.HttpURLConnection(new URL("http://localhost/"), (Proxy) null)
		models.put("firma", "conexion de " + conexion.getClass().getName())
	}
}
