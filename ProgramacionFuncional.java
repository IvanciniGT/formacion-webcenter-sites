import java.util.function.*;

import java.util.List;

// Contiene interfaces funcionales.
// Son interfaces para apuntar a funciones.
// 
// Cada interfaz ofrece una función/método que permite ejecutar la FUNCION QUE HAY DETRAS!
// Hay 4 principales:
// - Consumer<T>      Una función que aceptar un argumento y devuelve void.
//       Todos los setters son Comsumers
//       .accept(T t)
// - Supplier<T>      Una función que no acepta argumentos y devuelve un valor.
//       Todos los getters son Suppliers
//       .get()
// - Function<T, R>.  Una función que acepta un argumento T y devuelve un valor R.
//       .apply(T t)
// - Predicate<T>     Una función que acepta un argumento T y devuelve un boolean.
//       Son las típicas: isXXX, hasXXX.
//       .test(T t)

public class ProgramacionFuncional {
    

    public static void saluda(String nombre) {
        System.out.println("Hola " + nombre);
    }

    public static  String generarSaludoFormal(String nombre) {
        return "Estimado/a " + nombre;
    }

    public static String generarSaludoInformal(String nombre) {
        return "Hola " + nombre;
    }


    public static void imprimirSaludo(Function<String,String> generadorSaludo, String nombre) {
        String saludo = generadorSaludo.apply(nombre);
        System.out.println(saludo);
    }

    public static void main(String[] args) {
        saluda("Menchu");
        String nombre = "Menchu";
        saluda(nombre);

        Consumer<String> miVariable = ProgramacionFuncional::saluda ;
        miVariable.accept("Menchu");

        // Pre java 1.5, para iterar sobre un alista de elementos:
        List<Integer> numeros = List.of(1, 2, 3, 4, 5);
        for(int i = 0; i < numeros.size(); i++) {
            System.out.println(numeros.get(i));
        }
        
        // Con Java 1.5 en adelante, se puede usar el for-each (iterable):
        for(Integer numero : numeros) {
            System.out.println(numero);
        }
        // desde java 8, con programación funcional:
        numeros.forEach(System.out::println);

        imprimirSaludo(ProgramacionFuncional::generarSaludoFormal, "Menchu");   
        imprimirSaludo(ProgramacionFuncional::generarSaludoInformal, "Menchu");
        // Cuando tengo funciones creadas por necesidad, y no quiero ni reusarlas ni el tenerlas definidas de forma 
        // tracicional mejora la legibilidad, en Java 8, aparece otra forma de definir funciones
        // usando expresiones lambda.
        imprimirSaludo(
            (String unNombre) -> { // Defino la función dentro de la llamada a imprimirSaludo
                    return "Hola " + unNombre;
                }
            , "Menchu");
        imprimirSaludo( unNombre -> "Hola " + unNombre , "Menchu");
    }



    



}