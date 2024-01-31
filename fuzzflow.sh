#!/bin/bash

# Author: 0xju4ncaa

# Colores
GREEN="\e[1;92m"
RED="\e[1;91m"
YELLOW="\e[1;93m"
CYAN="\e[1;96m"
RESET="\e[1;97m"

# Verificar que se proporcionan los dos argumentos
print_help() {
    echo -e "\n${YELLOW}[*]${RESET} Ayuda: ${CYAN}$0${RESET} ${YELLOW}<diccionario> <url>${RESET} ${GREEN}[-s | --success-only]${RESET}"
    exit 1
}

if [ $# -lt 2 ]; then
    print_help
fi

dict=$1
url=$2
success_only=false

# Verificar que el diccionario proporcionado se encuentra en el sistema
if [ ! -f "$dict" ]; then
    echo -e "\n${RED}[!]${RESET} El diccionario '$dict' no existe"
    exit 1
fi

# Verificar url
if ! curl -s --head "$url" >/dev/null; then
    echo -e "\n${RED}[!]${RESET} La URL '$url' no es válida o no se puede acceder"
    exit 1
fi

# Verificar argumentos opcionales
while [[ $# -gt 2 ]]; do
    case "$3" in
        -s|--success-only)
            success_only=true
            shift
            ;;
        *)
            print_help
            ;;
    esac
done

# Verificar líneas del diccionario y controlar posición de comienzo
dict_lines=$(wc -l < "$dict")
start_line=0

# Leer las líneas y enviar peticiones
echo -e "\n"
while IFS= read -r line; do
    # Añadir barra de la url al final si no contiene
    if [[ "${url: -1}" != "/" ]]; then
        url="$url/"
    fi

    dir_url="$url/$line"
    response_code=$(curl -s -o /dev/null -w "%{http_code}" -I "$dir_url")

     if [ "$success_only" == true ]; then
        if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
            color=$GREEN  # Mostrar solo códigos de éxito en verde
        else
            continue  # Saltar a la siguiente iteración si no es un código de éxito
        fi
    else
        if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
            color=$GREEN  # Códigos de éxito (200-299) en verde
        else
            color=$RED    # Códigos de error en rojo
        fi
    fi

    echo -e "${CYAN}$dir_url${RESET} --> ${color}$response_code${RESET}"
done < "$dict"
