# FuzzFlow

<div align="center"><img src="https://github.com/0xju4ncaa/FuzzFlow/assets/130152767/22f95c36-b5a9-4630-9310-4c52b9fd4496" width="200px"></div><br>

Herramienta diseñada para la enumeración de directorios en aplicaciones web utilizando un diccionario de posibles rutas. La herramienta realiza solicitudes HTTP a cada ruta del diccionario y muestra información relevante, como el código de respuesta HTTP. El objetivo principal es identificar directorios accesibles y obtener información sobre la estructura de la aplicación.

## Características Principales
- **Uso de Diccionario:** La herramienta toma un diccionario que contiene posibles rutas de directorios.
- **Colores para Códigos de Estado:** Códigos de estado exitosos se muestran en verde, y códigos de error en rojo.
- **Opción para Mostrar Solo Códigos de Estado Exitosos:** Se proporciona una opción (`-s` o `--success-only`) para mostrar solo códigos de estado exitosos en la salida.

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
