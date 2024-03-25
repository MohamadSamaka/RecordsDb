
log_event() {
    echo -e "$(date '+%d/%m/%Y %H:%M:%S')\t$1\t$2\t$3\n" >> "$LOG_FILE"
}