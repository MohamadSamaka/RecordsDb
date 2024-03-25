#!/bin/bash

#add_record "Thriller" 5

source logging.sh
source helpers.sh


add_record(){
    local record_name="$1"
    local amount_to_add="$2"
    local search_result=$(search_record "$record_name")

    if [ ! -z "$search_result" ]; then # checks if record alread exist
        update_record_amount "$record_name" "$amount_to_add" "$search_result"
        return 0;
    fi

    echo "$record_name, $amount_to_add" >> $RECORD_FILE
    log_event "add_record" $name $amount
    colored_message "[+] Recorded been added successfully!" $green
}

remove_record(){
    local record_name="$1"
    local amount_to_add="$2"
    local search_result=$(search_record "$record_name")

    if [ ! -z "$search_result" ]; then # checks if record alread exist
        update_record_amount "$record_name" "$amount_to_add" "$search_result"
        return 0;
    fi

    # echo "$record_name, $amount_to_add" >> $RECORD_FILE
    # log_event "add_record" $name $amount
    colored_message "[+] Recorded been added successfully!" $green
}

search_record() {
    local pattern="^$1"
    local return_val="$2"
    # local exact_match="${2:-""}"
    # local matches=$(grep "${exact_match:+-w -e}" "$pattern" "$RECORD_FILE") # if it's exact match then it will add -w option
    local matches=$(grep "$pattern" "$RECORD_FILE") # if it's exact match then it will add -w option
    echo "-------------------------------" > /dev/tty
    if [[ -z "$matches" ]]; then
        echo ""
        return 1
    fi
    local choice=$(sub_operation_menu "$matches" "$return_val")
    echo $choice
}

update_record_name(){
    local record_name="$1"
    local new_name="$2"
    local search_result=$(search_record "$record_name")

    if [ -z "$search_result" ]; then # checks if record alread exist
        colored_message "$RECORD_MISSING" $red
        return 1
    fi

    local current_name="${search_result%%,*}"
    local current_amount="${search_result#*, }"
    sed -i "s/^$search_result/$new_name, $current_amount/" "$RECORD_FILE"
    log_event "update_record_amount" $record_name $amount_to_add
    log_event "update_record_amount" "Success"
    colored_message "[+] Recorded been updated successfully!" $green
    return 0;
    
}

update_record_amount(){
    local record_name="$1"
    local change_quantity="$2"
    local search_target="$3"
    local search_result
    if [[ -z $search_target ]]; then
        local search_result=$(search_record "$record_name")
    else
        local search_result=$search_target
    fi

    if [ -z "$search_result" ]; then # checks if search_result is empty
        colored_message "$RECORD_MISSING" $red > /dev/tty
        return 1
    fi

    local current_name="${search_result%%,*}"
    local current_amount="${search_result#*, }"
    local new_amount=$((current_amount + change_quantity))

    if (( $new_amount < 0 )); then
        colored_message "$EXCEEDS_ACTUAL_QUANTITY" $red > /dev/tty
        echo ""
    elif (( $new_amount == 0 )); then
        sed -i "/^$search_result\$/d" "$RECORD_FILE"
        colored_message "$DELETE_SUCESS" $green > /dev/tty
    else
        colored_message "$UPDATE_SUCESS" $green > /dev/tty
        sed -i "s/^$search_result/$current_name, $new_amount/" "$RECORD_FILE"
    fi
    echo ""
}

calculate_total_records(){
    local records_sum=$(awk -F, '{print $2}' "$RECORD_FILE" | awk '{sum += $1} END {print sum}')
    if ((${records_sum:-0} == 0)); then
        colored_message "[-] There is no records!" $red
    else
        colored_message "[+] # of $records_sum" $green
    fi
}

print_sorted_records(){
    # Count the number of lines in the file
    local line_count=$(wc -l < "$RECORD_FILE")
    # Check if line count is 0 (empty file)
    if [ "$line_count" -eq 0 ]; then
        colored_message "The file has no records." $red
    else
        colored_message "Sorted records:" $green
        sort "$RECORD_FILE"
    fi
}
