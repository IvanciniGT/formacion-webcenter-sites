package oracle.webcenter.sites.controller

import com.fatwire.assetapi.data.*

// Este NO COMPILA en Java 17: sun.misc.BASE64Encoder ya no existe. El error no
// sale al guardarlo, sino en Admin > System Tools > Controllers y al pedir la
// pagina. Solo se sube a proposito: ./subir.py --no-compila
public class CursoMigNoCompilaController extends BaseController
{
	public void doWork(Map models)
	{
		models.put("firma", new sun.misc.BASE64Encoder().encode("avisports".getBytes("UTF-8")))
	}
}
