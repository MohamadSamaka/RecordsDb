source menu.sh
source helpers.sh

RECORD_FILE="$1.rec"
LOG_FILE="._${RECORD_FILE}_log"

main(){
    app_index
}

main $1
