#!/bin/bash

# Colores ANSI
GREEN="\e[1;92m"
RED="\e[1;91m"
YELLOW="\e[1;93m"
CYAN="\e[1;96m"
PURPLE="\e[1;95m"
RESET="\e[1;97m"

# Funcion salir
trap ctrl_c INT
stty -ctlecho
function ctrl_c(){
    echo -e "\n\n${RED}[!]${RESET} Saliendo..."
    tput cnorm
    exit 0
}

# Función banner
function banner() {
    echo -e "${PURPLE} _____              _____ _${RESET}"
    echo -e "${PURPLE}|  ___|   _ _______|  ___| | _____      __${RESET}"
    echo -e "${PURPLE}| |_ | | | |_  /_  / |_  | |/ _ \ \ /\ / /${RESET}"
    echo -e "${YELLOW}|  _|| |_| |/ / / /|  _| | | (_) \ V  V / ${RESET}   (Hecho por ${PURPLE}0xju4ncaa${RESET})"
    echo -e "${YELLOW}|_|   \____/___/___|_|   |_|\___/ \_/\_/  ${RESET}"
}

# Ayuda
print_help() {
    echo -e "\n${YELLOW}[*]${RESET} Ayuda: ${CYAN}$0${RESET} ${YELLOW}-u <url> -w <wordlist> [-o <nombre_archivo>] [-s] [-e <extensiones>]${RESET}"
    exit 1
}

if [ $# -lt 4 ]; then
    print_help
fi

url=""
wordlist=""
output_file=""
success_only=false
extensions=""

while getopts ":u:w:o:se:" opt; do
    case $opt in
        u)
            url=$OPTARG
            ;;
        w)
            wordlist=$OPTARG
            ;;
        o)
            output_file=$OPTARG
            ;;
        s)
            success_only=true
            ;;
        e)
            extensions=$OPTARG
            ;;
        \?)
            echo "Opción inválida: -$OPTARG" >&2
            print_help
            ;;
        :)
            echo "La opción -$OPTARG requiere un argumento." >&2
            print_help
            ;;
    esac
done

# Comprobar si se proporcionaron la URL y el wordlist
if [ -z "$url" ] || [ -z "$wordlist" ]; then
    echo "Debe proporcionar una URL y un wordlist."
    print_help
fi

if [ ! -f "$wordlist" ]; then
    echo -e "\n${RED}[!]${RESET} El wordlist ${YELLOW}'$wordlist'${RESET} no existe"
    exit 1
fi

if ! curl -s --head "$url" >/dev/null; then
    echo -e "\n${RED}[!]${RESET} La URL ${YELLOW}'$url'${RESET} no es válida o no se puede acceder"
    exit 1
fi

# Asegurarse de que la URL termine con una barra
if [[ ! "$url" == */ ]]; then
    url="${url}/"
fi

basename=$(basename "$wordlist")
wordlist_lines=$(wc -l < "$wordlist")
iteration_line=0
success_count=0
fail_count=0

banner;tput civis
echo -e "\n\n${CYAN}[*]${RESET} URL: ${PURPLE}$url${RESET}"
echo -e "${CYAN}[*]${RESET} Diccionario: ${PURPLE}$basename${RESET}"
echo -e "\n\n${YELLOW}======================================================${RESET}"
echo -e "${YELLOW}ID    Response    Payload      ${RESET}"
echo -e "${YELLOW}======================================================${RESET}"
while IFS= read -r line; do
    ((iteration_line++))
    if [[ "$line" == *# ]]; then
        continue
    fi

    if [ -n "$extensions" ]; then
        for ext in $(echo $extensions | tr "," "\n"); do
            dir_url="${url}${line}.${ext}"
            response_code=$(curl -s -o /dev/null -w "%{http_code}" -I "$dir_url")

            if [ "$success_only" == true ]; then
                if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                    success_count=$((success_count + 1))
                    echo -e "${CYAN}${iteration_line}${RESET}:${GREEN}   ${response_code}       ${dir_url}      ${RESET}"
                fi
            else
                if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                    success_count=$((success_count + 1))
                    echo -e "${CYAN}${iteration_line}${RESET}:${GREEN}   ${response_code}       ${dir_url}      ${RESET}"
                else
                    fail_count=$((fail_count + 1))
                    echo -e "${CYAN}${iteration_line}${RESET}:${RED}   ${response_code}       ${dir_url}      ${RESET}"
                fi
            fi

            if [ -n "$output_file" ]; then
                echo "${dir_url} --> ${response_code}" >> "$output_file"
            fi
        done
    else
        dir_url="${url}${line}"
        response_code=$(curl -s -o /dev/null -w "%{http_code}" -I "$dir_url")

        if [ "$success_only" == true ]; then
            if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                success_count=$((success_count + 1))
                echo -e "${CYAN}${iteration_line}${RESET}:${GREEN}   ${response_code}       ${dir_url}      ${RESET}"
            fi
        else
            if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 300 ]; then
                success_count=$((success_count + 1))
                echo -e "${CYAN}${iteration_line}${RESET}:${GREEN}   ${response_code}       ${dir_url}      ${RESET}"
            else
                fail_count=$((fail_count + 1))
                echo -e "${CYAN}${iteration_line}${RESET}:${RED}   ${response_code}       ${dir_url}      ${RESET}"
            fi
        fi

        if [ -n "$output_file" ]; then
            echo "${dir_url} --> ${response_code}" >> "$output_file"
        fi
    fi
done < "$wordlist"

echo -e "${YELLOW}=====================================================================${RESET}"
echo -e "\n\n${CYAN}[+] Resumen:${RESET}"
echo -e "${GREEN}[+] Total de peticiones exitosas: ${success_count}${RESET}"
echo -e "${RED}[!] Total de peticiones fallidas: ${fail_count}${RESET}"
tput cnorm
