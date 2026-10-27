package oracle.webcenter.sites.controller

import com.fatwire.assetapi.data.*
import java.net.http.HttpClient

// El cliente http publico, desde Java 11
public class CursoMigBienController extends BaseController
{
	public void doWork(Map models)
	{
		def cliente = HttpClient.newHttpClient()
		models.put("firma", "cliente de " + cliente.getClass().getName())
	}
}
