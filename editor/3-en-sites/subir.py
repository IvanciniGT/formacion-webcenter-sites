#!/usr/bin/python3
"""Monta en Avisports TinyMCE con estilos y plantillas de maquetacion propios.

Uso:  ./subir.py            borra lo que subio la vez anterior y lo vuelve a crear
      ./subir.py --borrar   solo borra, y devuelve al atributo body su editor

Sube, por la API REST de Sites:
  - CursoMig/Editor/config    el config.js de TinyMCE, como pagina de Sites
  - CursoMig/Editor/estilos   el CSS, el mismo para el editor y para la pagina
  - la plantilla CursoMigEditor (AVIArticle), para editar en Web Mode
  - el editor de atributo CursoMigTinyMCE, para el formulario del Contributor,
    y se lo pone al atributo «body» de los articulos. --borrar le devuelve el
    suyo (TinyMCE500x300)
  - un articulo de prueba, «CursoMig · Editor», con esa plantilla

El config.js y el CSS van como paginas, y no como ficheros de la WAR, para no
tocar el despliegue: si alguien reinstala la WAR, siguen ahi.

Reutiliza la conexion de java17/5-sites/subir.py (CAS y la API REST).
"""
import base64
import json
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(AQUI, "..", "..", "java17", "5-sites"))
import subir as comun  # noqa: E402

IDS = os.path.join(AQUI, ".ids.json")
SITIO = comun.SITIO

ATRIBUTO_BODY = "1327351718509"
EDITOR_ORIGINAL = "AttrTypes:1700753592864"     # TinyMCE500x300
ARTICULO_MODELO = "1330881053255"               # «Agility Drills»: se copia para el de prueba
PLANTILLA = "CursoMigEditor"

EDITOR_XML = """<?XML VERSION="1.0"?>
<!DOCTYPE PRESENTATIONOBJECT SYSTEM "presentationobject.dtd">
<PRESENTATIONOBJECT NAME="tinymce"><TINYMCE WIDTH="700px" HEIGHT="450px" TOOLBAR="CursoMig" CONFIG="../ContentServer?pagename=CursoMig/Editor/config"></TINYMCE></PRESENTATIONOBJECT>"""


def texto(nombre, valor):
    return {"name": nombre, "data": {"stringValue": valor}}


def lista(nombre, valores):
    return {"name": nombre, "data": {"stringList": valores}}


def blob(nombre, fichero, contenido):
    return {"name": nombre, "data": {"blobValue": {
        "filename": fichero, "filedata": base64.b64encode(contenido).decode()}}}


def leer(ruta):
    with open(os.path.join(AQUI, ruta), "rb") as f:
        return f.read()


def pagina(sites, ids, pagename, fichero, tipo):
    """Un CSElement y su SiteEntry, sin cache: si no, al cambiar el CSS seguiriais viendo el viejo.

    El tipo va como argumento por defecto cs.contenttype (resargs1 en SiteCatalog,
    como rest/asset). Ni response.setContentType, ni <%@ page contentType %>, ni
    ics.StreamHeader lo cambian: Sites contesta text/html con nosniff, y el
    navegador no ejecuta ese JS ni aplica ese CSS (probado el 28-10-2026).
    """
    ids["CSElement " + pagename] = elemento = sites.crear("CSElement", {
        "name": pagename, "description": "Curso de migracion: editor", "publist": [SITIO],
        "attribute": [texto("rootelement", pagename), texto("elementname", pagename),
                      comun.fichero(pagename, ".jsp", leer("elementos/" + fichero))]})
    ids["SiteEntry " + pagename] = sites.crear("SiteEntry", {
        "name": pagename, "description": "Curso de migracion: editor", "publist": [SITIO],
        "attribute": [texto("pagename", pagename), texto("rootelement", pagename),
                      texto("cselement_id", elemento), texto("cs_wrapper", "n"),
                      texto("cscacheinfo", "false"), texto("sscacheinfo", "false"),
                      texto("csstatus", "live"), texto("pageletonly", "false"), texto("acl", ""),
                      {"name": "defaultarguments", "data": {"structList": [
                          {"item": [texto("name", "cs.contenttype"), texto("value", tipo)]}]}}]})
    json.dump(ids, open(IDS, "w"), indent=1)


def plantilla(sites, ids):
    elemento = "AVIArticle/" + PLANTILLA
    argumentos = [{"item": [texto("name", n), texto("value", v)]}
                  for n, v in [("c", "AVIArticle"), ("rendermode", "live"), ("site", SITIO)]]
    ids["Template " + PLANTILLA] = sites.crear("Template", {
        "name": PLANTILLA, "description": "Curso de migracion: TinyMCE con estilos y plantillas",
        "publist": [SITIO], "subtype": "AVIArticle",
        "attribute": [
            texto("rootelement", elemento),
            texto("ttype", "l"),                       # layout: se elige como plantilla del articulo
            texto("controller", "AVIArticleDetailController"),   # pone ${asset}
            texto("category", "banr"),
            lista("acl", [""]),
            lista("applicablesubtypes", ["Article"]),
            lista("pagecriteria", ["c", "cid", "context", "d", "deviceid", "p", "rendermode", "site", "sitepfx", "ft_ss"]),
            {"name": "element", "data": {"structList": [{"item": [
                texto("elementname", elemento),
                {"name": "siteentry", "data": {"structList": [{"item": [
                    {"name": "defaultarguments", "data": {"structList": argumentos}},
                    texto("pagename", f"{SITIO}/{elemento}")]}]}},
                texto("cscacheinfo", "false"), texto("sscacheinfo", "false"),
                texto("csstatus", "live"), texto("description", ""),
                blob("url", elemento + ".jsp", leer("elementos/ArticuloEditor.jsp"))]}]}},
        ]})
    json.dump(ids, open(IDS, "w"), indent=1)


def editor_de_atributo(sites, ids):
    ids["AttrTypes CursoMigTinyMCE"] = sites.crear("AttrTypes", {
        "name": "CursoMigTinyMCE", "description": "Curso de migracion: TinyMCE con estilos y plantillas",
        "publist": [SITIO],
        "attribute": [texto("valuetype", "string,text"),
                      blob("urlxml", "CursoMigTinyMCE.txt", EDITOR_XML.encode())]})
    json.dump(ids, open(IDS, "w"), indent=1)


def poner_editor_a_body(sites, editor):
    """Cambia SOLO el editor del atributo body: lo demas se manda tal cual estaba."""
    estado, texto_ = sites.rest("GET", f"ContentAttribute/assets/{ATRIBUTO_BODY}")
    if estado != 200:
        sys.exit(f"No se pudo leer el atributo body: {estado} {texto_[:200]}")
    atributo = json.loads(texto_)
    for a in atributo["attribute"]:
        if a["name"] == "attributetype":
            a["data"] = {"stringValue": editor}
    # En la API REST de Sites, POST sobre un id es ACTUALIZAR; PUT intenta crear
    # otro con el mismo nombre (y falla con -12075)
    estado, texto_ = sites.rest("POST", f"ContentAttribute/assets/{ATRIBUTO_BODY}", atributo)
    if estado not in (200, 201):
        sys.exit(f"No se pudo cambiar el editor de body: {estado} {texto_[:300]}")
    print(f"  body usa ahora {editor}")


def articulo(sites, ids):
    estado, texto_ = sites.rest("GET", f"AVIArticle/assets/{ARTICULO_MODELO}")
    if estado != 200:
        sys.exit(f"No se pudo leer el articulo modelo: {estado} {texto_[:200]}")
    modelo = json.loads(texto_)
    cuerpo = {"name": "CursoMig · Editor", "description": "Curso de migracion: editor",
              "publist": [SITIO], "subtype": modelo.get("subtype", "Article"), "attribute": []}
    for a in modelo["attribute"]:
        if a["name"] in ("id", "fw_uid", "name", "description", "Webreference"):
            continue
        if a["name"] == "template":
            a = texto("template", PLANTILLA)
        elif a["name"] == "headline":
            a = texto("headline", "Curso de migración: TinyMCE con estilos y plantillas")
        elif a["name"] == "body":
            a = texto("body", "<div>Pinchad aquí para editar. Probad el desplegable de "
                              "<b>estilos</b> y el botón de <b>plantillas</b>.</div>")
        cuerpo["attribute"].append(a)
    if not any(a["name"] == "template" for a in cuerpo["attribute"]):
        cuerpo["attribute"].append(texto("template", PLANTILLA))
    for campo in ("parent", "dimension", "dimensionParent"):
        if modelo.get(campo):
            cuerpo[campo] = modelo[campo]
    ids["AVIArticle CursoMig"] = sites.crear("AVIArticle", cuerpo)
    json.dump(ids, open(IDS, "w"), indent=1)


def main():
    sites = comun.Sites()
    ids = json.load(open(IDS)) if os.path.exists(IDS) else {}

    if ids:
        print("Borrando lo subido la vez anterior...")
        if "AttrTypes CursoMigTinyMCE" in ids:
            poner_editor_a_body(sites, EDITOR_ORIGINAL)
        # Primero lo que apunta a otras cosas: articulo, SiteEntry
        orden = ["AVIArticle", "SiteEntry", "Template", "AttrTypes", "CSElement"]
        for ref in sorted(ids.values(), key=lambda r: orden.index(r.split(":")[0])):
            sites.borrar(ref)
        ids = {}
        json.dump(ids, open(IDS, "w"), indent=1)
    if "--borrar" in sys.argv:
        return

    print("Subiendo a " + SITIO + "...")
    pagina(sites, ids, "CursoMig/Editor/config", "config.jsp", "application/javascript; charset=UTF-8")
    pagina(sites, ids, "CursoMig/Editor/estilos", "estilos.jsp", "text/css; charset=UTF-8")
    plantilla(sites, ids)
    editor_de_atributo(sites, ids)
    poner_editor_a_body(sites, ids["AttrTypes CursoMigTinyMCE"])
    articulo(sites, ids)
    print("Hecho. El articulo «CursoMig · Editor»: " + ids["AVIArticle CursoMig"])


if __name__ == "__main__":
    main()
