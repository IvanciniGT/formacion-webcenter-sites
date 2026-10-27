
def saluda(nombre):
    print("Hola " + nombre)

nombre = "Menchu"
saluda(nombre)

miVariable = saluda  # Referenciamos la función desde la variable.
# Lo que meto en la variable es la función. NO SU RESULTADO, LA FUNCION!

miVariable(nombre)  # Llamamos a la función a través de la variable.
miVariable("Menchu")  # Llamamos a la función a través de la variable con otro argumento.

def doble (numero):
    return numero * 2

def multiplicar (numero, numero2):
    return numero * numero2

resultado = doble(5)
print(resultado)

resultado2 = multiplicar(3, 4)
print(resultado2)


def generar_salud_formal(nombre):
    return "Buenos días, " + nombre + ". Es un placer saludarle."

def generar_salud_informal(nombre):
    return "Hola " + nombre + ", ¿cómo estás?"

def imprimir_saludo(funcion_generadora_de_saludos, nombre):
    saludo = funcion_generadora_de_saludos(nombre)
    print(saludo)

imprimir_saludo(generar_salud_formal, "Menchu")
#imprimir_saludo(generar_salud_formal( "Menchu"))

imprimir_saludo(generar_salud_informal, "Federico")