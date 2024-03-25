#!/bin/bash

source operations.sh
source colors.sh
source errors.sh
source success.sh

show_menu(){
    printf "\n${blue}*********************************************${normal}\n"
    printf "${blue}**${yellow} 1)${blue} create new record ${normal}\n"
    printf "${blue}**${yellow} 2)${blue} Remove records ${normal}\n"
    printf "${blue}**${yellow} 3)${blue} Search for record ${normal}\n"
    printf "${blue}**${yellow} 4)${blue} Change record name ${normal}\n"
    printf "${blue}**${yellow} 5)${blue} Add records ${normal}\n"
    printf "${blue}**${yellow} 6)${blue} Calcualte total records ${normal}\n"
    printf "${blue}**${yellow} 7)${blue} Print Records Sorted ${normal}\n"
    printf "${blue}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${red}x to exit. ${normal}\n"
    read opt
}


app_index(){
    while :
    do
        clear
        show_menu
        case $opt in
            1)  
                clear;
                read -p "[!] Insert record name add/update"$'\n' record_name
                read -p "[!] Insert record quantity"$'\n' record_quanitiy
                local to_validate=($record_quanitiy)
                local rules=($POSITIVE_NUMBER_ONLY)
                local error=("$ZERO_NEGATIVE_NUMBER")
                if input_handler to_validate rules error ; then
                    add_record $record_name $record_quanitiy
                fi
            ;;
            2)  
                clear;
                read -p "[!] Insert record name to edit"$'\n' record_name
                read -p "[!] Insert quantity to remove"$'\n' amount_to_remove
                local to_validate=($amount_to_remove)
                local rules=($POSITIVE_NUMBER_ONLY)
                local error=("$ZERO_NEGATIVE_NUMBER")
                if input_handler to_validate rules error ; then
                    amount_to_remove=$((amount_to_remove * -1))
                    local update_res=$(update_record_amount $record_name $amount_to_remove)
                fi
            ;;
            3)  
                clear;
                read -p "[!] Insert a pattern to search for:"$'\n' pattern
                if [[ -z $(search_record $pattern "X") ]]; then
                    colored_message "[-] No matches found in $RECORD_FILE for pattern '$pattern'" $red > /dev/tty
                else continue
                fi
            ;;
            4)  
                clear;
                read -p "[!] Insert a record to update"$'\n' record_name
                read -p "[!] Insert the record's new name"$'\n' new_record_name
                update_record_name $record_name $new_record_name
            ;;
            5)  
                clear;
                read -p "[!] Insert record name to edit"$'\n' record_name
                read -p "[!] Insert quantity to add"$'\n' amount_to_add
                local to_validate=($amount_to_add)
                local rules=($POSITIVE_NUMBER_ONLY)
                local error=("$ZERO_NEGATIVE_NUMBER")
                if input_handler to_validate rules error ; then
                    local update_res=$(update_record_amount $record_name $amount_to_add)
                fi
            ;;
            6)  
                clear;
                calculate_total_records
            ;;
            7)  
                clear;
                print_sorted_records
            ;;
            x)  
                exit;
            ;;
            X)  
                exit;
            ;;
            *)  
                clear;
                colored_message "Pick an option from the menu" $red
            ;;
        esac
        read -p "[!] Press enter to continue"
    done
}