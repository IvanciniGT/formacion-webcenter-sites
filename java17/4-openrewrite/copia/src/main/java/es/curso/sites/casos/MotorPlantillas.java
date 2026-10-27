package es.curso.sites.casos;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

// CASO: Nashorn, el JavaScript del JDK. Lo interesante es que COMPILA en Java 17
// —javax.script sigue existiendo—, pero getEngineByName devuelve null porque el
// motor ya no viene: falla en EJECUCION, no al compilar.
public class MotorPlantillas {

    public Object evaluar(String expresion) throws Exception {
        ScriptEngine motor = new ScriptEngineManager().getEngineByName("nashorn");
        return motor.eval(expresion);
    }
}
