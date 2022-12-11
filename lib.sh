cleanups=()
cleanup() {
    for cleanupScript in "${cleanups[@]}"; do
        echo "cleanup: $cleanupScript"
        eval "$cleanupScript"
    done
}
trap 'cleanup' EXIT

clean_last_pid_up_fam() {
    cleanups+=("kill -9 '$!'")
}
