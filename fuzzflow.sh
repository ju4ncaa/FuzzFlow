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

# Ayuda
print_help() {
    echo -e "\n${YELLOW}[i]${RESET} Ayuda: ${CYAN}$0${RESET} ${YELLOW}<diccionario> <url>${RESET} ${GREEN}[-s | --success-only]${RESET} ${GREEN}[-w | --output-file <nombre_archivo>]${RESET} ${GREEN}[-e | --extensions <extensiones>]${RESET}"
    exit 1
}

if [ $# -lt 2 ]; then
    print_help
fi

dict=$1
url=$2
success_only=false
output_file=""
extensions=""

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
        -e|--extensions)
            if [ -n "$4" ]; then
                extensions="$4"
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

if [ ! -f "$dict" ]; then
    echo -e "\n${RED}[!]${RESET} El diccionario ${YELLOW}'$dict'${RESET} no existe"
    exit 1
fi

if ! curl -s --head "$url" >/dev/null; then
    echo -e "\n${RED}[!]${RESET} La URL ${YELLOW}'$url'${RESET} no es válida o no se puede acceder"
    exit 1
fi

dict_lines=$(wc -l < "$dict")

echo -e "\n"
while IFS= read -r line; do
    if [[ "$url" == */ ]]; then
        url="${url%/}"
    fi

    if [[ "$line" == *# ]]; then
        continue
    fi

    if [ -n "$extensions" ]; then
        for ext in $(echo $extensions | tr "," "\n"); do
            dir_url="$url/$line.$ext"
            response_code=$(curl -s -o /dev/null -w "%{http_code}" -I "$dir_url")

            if [ "$success_only" == true ]; then
                if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                    color=$GREEN
                else
                    continue
                fi
            else
                if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                    color=$GREEN
                else
                    color=$RED
                fi
            fi

            echo -e "${CYAN}$dir_url${RESET} --> ${color}$response_code${RESET}"

            if [ -n "$output_file" ]; then
                echo "$dir_url --> $response_code" >> "$output_file"
            fi
        done
    else
        dir_url="$url/$line"
        response_code=$(curl -s -o /dev/null -w "%{http_code}" -I "$dir_url")

        if [ "$success_only" == true ]; then
            if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                color=$GREEN
            else
                continue
            fi
        else
            if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                color=$GREEN
            else
                color=$RED
            fi
        fi

        echo -e "${CYAN}$dir_url${RESET} --> ${color}$response_code${RESET}"

        if [ -n "$output_file" ]; then
            echo "$dir_url --> $response_code" >> "$output_file"
        fi
    fi

done < "$dict"
