# FuzzFlow

<div align="center"><img src="https://github.com/0xju4ncaa/FuzzFlow/assets/130152767/84541a86-ca86-4df3-a424-a2853261bfba" width="300px"></div><br>

Herramienta diseñada para la enumeración de directorios en aplicaciones web utilizando un diccionario de posibles rutas. La herramienta realiza solicitudes a cada ruta del diccionario y muestra información relevante, como el código de respuesta. El objetivo principal es identificar directorios accesibles y obtener información sobre la estructura de la aplicación.

## Características Principales
### **Uso de Diccionario** 
La herramienta toma un diccionario que contiene posibles rutas de directorios.
### **Colores para Códigos de Estado** 
Códigos de estado exitosos se muestran en verde, y códigos de error en rojo.
### **Opción para Mostrar Solo Códigos de Estado Exitosos:** 
Se proporciona una opción (`-s` o `--success-only`) para mostrar solo códigos de estado exitosos en la salida.
### **Opción de guardar el escaneo en fichero**
Se proporciona una opción (`-w, --output-file`) para guardar la salida del escaneo en un archivo especificado.

## Uso Básico
```bash
./fuzzer.sh diccionario.txt http://ejemplo.com
```

## Uso con Opción de Códigos de Estado Exitosos
Este comando ejecutará la herramienta y mostrará solo los códigos de estado exitosos. en el rango (200-299).
```bash
./fuzzer.sh diccionario.txt http://ejemplo.com -s
```
## Ejemplo de uso con Metasploitable2
![image](https://github.com/0xju4ncaa/FuzzFlow/assets/130152767/03418008-b2ec-4b4c-83b4-bd6247d6e76d)
