#!/bin/bash

# Author: 0xju4ncaa

# Colores
GREEN="\e[1;92m"
RED="\e[1;91m"
YELLOW="\e[1;93m"
CYAN="\e[1;96m"
RESET="\e[1;97m"

# Funcion salir
trap ctrl_c INT
stty -ctlecho
function ctrl_c(){
    echo -e "\n\n${RED}[!]${RESET} Saliendo..."
    exit 0
}

# Verificar que se proporcionan los dos argumentos
print_help() {
    echo -e "\n${YELLOW}[*]${RESET} Ayuda: ${CYAN}$0${RESET} ${YELLOW}<diccionario> <url>${RESET} ${GREEN}[-s | --success-only]${RESET} ${GREEN}[-w | --output-file <nombre_archivo>]${RESET}"
    exit 1
}

if [ $# -lt 2 ]; then
    print_help
fi

dict=$1
url=$2
success_only=false
output_file=""

# Verificar que el diccionario proporcionado se encuentra en el sistema
if [ ! -f "$dict" ]; then
    echo -e "\n${RED}[!]${RESET} El diccionario ${YELLOW}'$dict'${RESET} no existe"
    exit 1
fi

# Verificar url
if ! curl -s --head "$url" >/dev/null; then
    echo -e "\n${RED}[!]${RESET} La URL ${YELLOW}'$url'${RESET} no es válida o no se puede acceder"
    exit 1
fi

# Verificar argumentos opcionales
while [[ $# -gt 2 ]]; do
    case "$3" in
        -s|--success-only)
            success_only=true
            shift
            ;;
        -w|--output-file)
            if [ -n "$4" ]; then
                output_file="$4"
                shift 2
            else
                print_help
            fi
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

    # Quitar barra de la url si contiene al final
    if [[ "$url" == */ ]]; then
        url="${url%/}"
    fi

    # Saltar líneas con '#'
    if [[ "$line" == *# ]]; then
        continue
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

    # Guardar la salida en el archivo si se especificó un nombre de archivo
    if [ -n "$output_file" ]; then
        echo "$dir_url --> $response_code" >> "$output_file"
    fi

done < "$dict"
