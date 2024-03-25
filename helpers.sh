source rules.sh

print_sub_menu(){
    local -n arrRef="$1"
    for i in "${!arrRef[@]}"; do
        colored_message "$((i + 1))) ${normal}${arrRef[$i]}" $blue
    done
}

grep_result_to_array(){
    local -n arrRef="$1"
    while IFS= read -r line; do
        arrRef+=("$line")
    done <<< "$2"
}

sub_operation_menu(){
    local matches_array=()
    local choice
    local return_val="$2"
    grep_result_to_array matches_array "$1"

    IFS=$'\n' matches_array=($(printf "%s\n" "${matches_array[@]}" | sort))
    unset IFS
    # printf "%s\n" "${sorted_array[@]}" > /dev/tty

    local length=${#matches_array[@]}
        
    if (($length == 1)); then #if grep got only 1 match just return it
        echo "${matches_array[0]}"
        return 0
    # elif ((length == 0)) then
    #     echo ""
    #     return 1
    fi
    # if [[ $length -eq 1 && -z $return_val ]]; then
    #     echo "${matches_array[0]}"
    #     return 0
    # fi

    while true; do
        clear > /dev/tty;
        colored_message "[!] ${normal}insert X to go back" $yellow > /dev/tty
        echo "" > /dev/tty
        print_sub_menu matches_array > /dev/tty
        echo "" > /dev/tty
        if [[ -z $return_val ]]; then
            colored_message "[!] ${normal}There is many, select one from the above list: " $yellow > /dev/tty
        fi
        read choice
        if [[ $choice =~ ^[Xx]$ ]]; then
            clear > /dev/tty;
            echo "X";
            return 0;
        fi

        if [[ $choice =~ $POSITIVE_NUMBER_ONLY && -z $return_val ]] && (( $choice >= 1 && $choice <= $length )); then
            clear > /dev/tty
            break
        fi

        clear > /dev/tty;
        if [[ -z $return_val ]]; then
            colored_message "Make sure of your input, your choice should be between [1 - $length]" $red > /dev/tty 
            colored_message "[!] ${normal}Press enter to try again!" $yellow > /dev/tty
        fi
        clear > /dev/tty;
    done

    echo "${matches_array[(($choice-1))]}"
}


colored_message(){
    local message=${1:-"${red}[-] Error: No message passed"}
    local color=${2:-normal}
    printf "${color}${message}${normal}\n"
}


input_handler(){
    local -n to_validate_arr=$1
    local -n rule_arr=$2
    local -n errors_arr=$3
    for (( i=0; i<${#to_validate_arr[@]}; i++ )); do
        if [[ ! ${to_validate[$i]} =~ ${rule_arr[$i]} ]]; then
            colored_message "${errors_arr[$i]}" $red > /dev/tty
            return 1;
        fi
    done
    return 0;
}

# create_files_as_necessary(){
#     if test -f "$RECORD_FILE"; then
#         touch
#     fi
# }