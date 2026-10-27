#!/usr/bin/python3
"""Sube a Avisports los casos de migracion, version Roto y version Bien.

Uso:  ./subir.py            borra lo que subio la vez anterior y lo vuelve a crear
      ./subir.py --borrar   solo borra
      ./subir.py --no-compila  ademas sube un controlador que no compila, para
                               ver como lo cuenta Sites. Se quita con ./subir.py

Va por la API REST de Sites, como iria un despliegue de verdad, y no copiando
ficheros al PV: asi Sites crea las filas de ElementCatalog y SiteCatalog que
hacen que la pagina exista.

Actualizar un CSElement por REST no reescribe su JSP (comprobado el 27-10-2026:
la API contesta 200 y el fichero sigue igual). Por eso se borra y se crea.
La busqueda REST tampoco sirve para encontrarlos por nombre mientras OpenSearch
no este configurado, asi que los ids se guardan en .ids.json.
"""
import base64
import json
import os
import socket
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request

HOST = "webcenter.ivanosuna.com"
# Desde casa el nombre resuelve a la IP publica, que pasa por Keycloak. El
# ingress interno no, y la API REST necesita hablar con Sites sin ese paso.
IP = os.environ.get("SITES_IP", "192.168.2.252")
BASE = "https://" + HOST
SITIO = "avisports"
USUARIO = os.environ.get("SITES_USUARIO", "fwadmin")
AQUI = os.path.dirname(os.path.abspath(__file__))
IDS = os.path.join(AQUI, ".ids.json")

_getaddrinfo = socket.getaddrinfo
socket.getaddrinfo = lambda h, *a, **k: _getaddrinfo(IP if h == HOST else h, *a, **k)

PAQUETE_CONTROLADORES = "WCS_Controller/oracle/webcenter/sites/controller/"

# (pagina y elemento, fichero, controlador o None)
CASOS = [
    ("CursoMig/Indice", "Indice.jsp", None),
    ("CursoMig/QueHayEnElServidor", "QueHayEnElServidor.jsp", None),
    ("CursoMig/CompilarControladores", "CompilarControladores.jsp", None),
]
for caso in ["Base64", "SunHttp", "Nashorn", "CommonsLang", "Jaxb"]:
    for version in ["Roto", "Bien"]:
        CASOS.append((f"CursoMig/{version}/{caso}", f"{version.lower()}/{caso}.jsp", None))
for version in ["Roto", "Bien"]:
    CASOS.append((f"CursoMig/{version}/Groovy", "Groovy.jsp", f"CursoMig{version}Controller"))
if "--no-compila" in sys.argv:
    CASOS.append(("CursoMig/NoCompila/Groovy", "Groovy.jsp", "CursoMigNoCompilaController"))


def contrasena():
    if os.environ.get("SITES_PASSWORD"):
        return os.environ["SITES_PASSWORD"]
    # Es la misma contrasena para todo el entorno (ver el playbook 120-webcenter-sites)
    salida = subprocess.run(
        ["kubectl", "-n", "webcenter", "get", "secret", "wcsitesinfra-domain-credentials",
         "-o", "jsonpath={.data.password}"], check=True, capture_output=True, text=True)
    return base64.b64decode(salida.stdout).decode()


def peticion(metodo, url, datos=None, cabeceras=None):
    req = urllib.request.Request(url, data=datos, method=metodo, headers=cabeceras or {})
    try:
        with urllib.request.urlopen(req) as r:
            return r.status, r.headers, r.read().decode()
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read().decode()


class Sites:
    def __init__(self):
        datos = urllib.parse.urlencode({"username": USUARIO, "password": contrasena()}).encode()
        estado, cabeceras, _ = peticion("POST", BASE + "/cas/v1/tickets", datos)
        if estado != 201:
            sys.exit(f"CAS no da ticket ({estado}): ¿usuario o contrasena?")
        # CAS devuelve la URL con http y puerto 80, que fuera del cluster no lleva a el
        ruta = urllib.parse.urlparse(cabeceras["Location"]).path
        self.tgt = BASE + ruta

    def ticket(self):
        _, _, st = peticion("POST", self.tgt, b"service=*",
                            {"Content-Type": "application/x-www-form-urlencoded"})
        return st

    def rest(self, metodo, ruta, cuerpo=None):
        url = f"{BASE}/sites/REST/sites/{SITIO}/types/{ruta}?multiticket={self.ticket()}"
        datos = json.dumps(cuerpo).encode() if cuerpo is not None else None
        estado, _, texto = peticion(metodo, url, datos, {
            "Content-Type": "application/json", "Accept": "application/json"})
        return estado, texto

    def crear(self, tipo, cuerpo):
        estado, texto = self.rest("POST", f"{tipo}/assets", cuerpo)
        if estado not in (200, 201):
            sys.exit(f"No se pudo crear {tipo} {cuerpo['name']}: {estado} {texto[:300]}\n"
                     "Si dice que ya existe y no esta en .ids.json, borradlo desde la "
                     "interfaz de Sites (o del .ids.json de otra maquina).")
        return json.loads(texto)["id"]

    def borrar(self, ref):
        tipo, ident = ref.split(":")
        estado, texto = self.rest("DELETE", f"{tipo}/assets/{ident}")
        print(f"  borrado {ref}" if estado in (200, 204) else f"  NO se pudo borrar {ref}: {estado} {texto[:200]}")


def texto(nombre, valor):
    return {"name": nombre, "data": {"stringValue": valor}}


def fichero(nombre, extension, contenido):
    return {"name": "url", "data": {"blobValue": {
        "filename": nombre + extension, "filedata": base64.b64encode(contenido).decode()}}}


def leer(ruta):
    with open(os.path.join(AQUI, ruta), "rb") as f:
        return f.read()


def main():
    sites = Sites()
    ids = json.load(open(IDS)) if os.path.exists(IDS) else {}

    if ids:
        print("Borrando lo subido la vez anterior...")
        # Primero las SiteEntry, que apuntan a los CSElement
        for ref in sorted(ids.values(), key=lambda r: not r.startswith("SiteEntry")):
            sites.borrar(ref)
        ids = {}
        json.dump(ids, open(IDS, "w"), indent=1)
    if "--borrar" in sys.argv:
        return

    print("Subiendo a " + SITIO + "...")
    for pagina, ruta, controlador in CASOS:
        if controlador and controlador not in ids:
            elemento = PAQUETE_CONTROLADORES + controlador
            ids[controlador] = sites.crear("WCS_Controller", {
                "name": controlador, "description": controlador, "publist": [SITIO],
                "attribute": [texto("rootelement", elemento), texto("elementname", elemento),
                              fichero(elemento, ".groovy", leer(f"controladores/{controlador}.groovy"))]})
        ids["CSElement " + pagina] = elemento_id = sites.crear("CSElement", {
            "name": pagina, "description": "Curso de migracion", "publist": [SITIO],
            "attribute": [texto("rootelement", pagina), texto("elementname", pagina),
                          fichero(pagina, ".jsp", leer("elementos/" + ruta))]})
        atributos = [texto("pagename", pagina), texto("rootelement", pagina),
                     texto("cselement_id", elemento_id), texto("cs_wrapper", "n"),
                     # Sin cache: si no, tras arreglar un caso seguiriais viendo el error
                     texto("cscacheinfo", "false"), texto("sscacheinfo", "false"),
                     texto("csstatus", "live"), texto("pageletonly", "false"), texto("acl", "")]
        if controlador:
            atributos.append(texto("controller", controlador))
        ids["SiteEntry " + pagina] = sites.crear("SiteEntry", {
            "name": pagina, "description": "Curso de migracion", "publist": [SITIO],
            "attribute": atributos})
        json.dump(ids, open(IDS, "w"), indent=1)
        print(f"  {BASE}/sites/ContentServer?pagename={pagina}")

    print("Compilando los controladores...")
    _, _, salida = peticion("GET", BASE + "/sites/ContentServer?pagename=CursoMig/CompilarControladores")
    print(salida.replace("<pre>", "").replace("</pre>", "").strip())


if __name__ == "__main__":
    main()
