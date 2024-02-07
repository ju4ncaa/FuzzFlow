# FuzzFlow

<div align="center"><img src="https://github.com/0xju4ncaa/FuzzFlow/assets/130152767/8cd34e10-0575-4f7f-aa57-f11c29e0cd42" width="300px"></div><br>

Herramienta diseñada para la enumeración de directorios en aplicaciones web utilizando un diccionario de posibles rutas. La herramienta realiza solicitudes a cada ruta del diccionario y muestra información relevante, como el código de respuesta. El objetivo principal es identificar directorios accesibles y obtener información sobre la estructura de la aplicación.

## Características Principales
### **Uso de Diccionario** 
La herramienta toma un diccionario que contiene posibles rutas de directorios.
### **Colores para Códigos de Estado** 
Códigos de estado exitosos se muestran en verde, y códigos de error en rojo.
### **Opción para Mostrar Solo Códigos de Estado Exitosos:** 
Se proporciona una opción (`-s` o `--success-only`) para mostrar solo códigos de estado exitosos en la salida.
### **Opción de guardar el escaneo en fichero**
Se proporciona una opción (`-w` o `--output-file`) para guardar la salida del escaneo en un archivo especificado.
### **Buscar por extensión de archivo**
Con la opción (`-e` o `--extensions`) es posible buscar por extensiones de archivos como txt, php, etc...

## Uso Básico
```bash
./fuzzer.sh diccionario.txt http://ejemplo.com
```

## Uso con Opción de Códigos de Estado Exitosos
Este comando ejecutará la herramienta y mostrará solo los códigos de estado exitosos. en el rango (200-299).
```bash
./fuzzer.sh diccionario.txt http://ejemplo.com -s
```
## Imagen de la herramienta
![image](https://github.com/0xju4ncaa/FuzzFlow/assets/130152767/c2c9b6b2-3a2f-466d-a3dc-1d594c77ad12)
