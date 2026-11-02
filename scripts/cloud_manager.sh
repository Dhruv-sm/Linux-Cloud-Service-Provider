#!/bin/bash

PROJECT_DIR="$HOME/cloud-service-provider"
CLIENT_DIR="/srv/cloud-storage/clients"
LOG_FILE="$PROJECT_DIR/logs/system.log"
BACKUP_DIR="$PROJECT_DIR/backups"

mkdir -p "$PROJECT_DIR/logs" "$PROJECT_DIR/data" "$BACKUP_DIR" "$CLIENT_DIR"

log_action() {
    echo "$(date '+%F %T') | $1" >> "$LOG_FILE"
}

pause_screen() {
    echo
    read -rp "Press Enter to continue..."
}

client_management() {
    while true; do
        clear
        echo "========== CLIENT MANAGEMENT =========="
        echo "1. Register client"
        echo "2. List clients"
        echo "3. Return"
        read -rp "Choose [1-3]: " choice

        case "$choice" in
            1)
                read -rp "Client name: " name
                if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                    echo "ERROR: Invalid client name."
                elif [[ -e "$CLIENT_DIR/$name" ]]; then
                    echo "ERROR: Client already exists."
                elif mkdir "$CLIENT_DIR/$name"; then
                    chmod 750 "$CLIENT_DIR/$name"
                    echo "$name" >> "$PROJECT_DIR/data/clients.txt"
                    echo "Client registered: $name"
                    log_action "Client registered: $name"
                else
                    echo "ERROR: Registration failed."
                fi
                pause_screen
                ;;
            2)
                if [[ -s "$PROJECT_DIR/data/clients.txt" ]]; then
                    cat "$PROJECT_DIR/data/clients.txt"
                else
                    echo "No clients registered."
                fi
                pause_screen
                ;;
            3) return ;;
            *) echo "Invalid choice."; pause_screen ;;
        esac
    done
}

storage_management() {
    while true; do
        clear
        echo "========== STORAGE MANAGEMENT =========="
        echo "1. Show filesystem capacity"
        echo "2. Show client storage usage"
        echo "3. Show LVM configuration"
        echo "4. Return"
        read -rp "Choose [1-4]: " choice

        case "$choice" in
            1) df -h /srv/cloud-storage; pause_screen ;;
            2)
                read -rp "Client name: " name
                if [[ -d "$CLIENT_DIR/$name" ]]; then
                    du -sh "$CLIENT_DIR/$name"
                else
                    echo "Client directory not found."
                fi
                pause_screen
                ;;
            3)
                sudo pvs
                sudo vgs
                sudo lvs
                pause_screen
                ;;
            4) return ;;
            *) echo "Invalid choice."; pause_screen ;;
        esac
    done
}

backup_management() {
    clear
    echo "========== BACKUP MANAGEMENT =========="
    read -rp "Client name to back up: " name
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ || ! -d "$CLIENT_DIR/$name" ]]; then
        echo "ERROR: Invalid or unregistered client."
    else
        archive="$BACKUP_DIR/${name}_$(date +%Y%m%d_%H%M%S).tar.gz"
        if tar -czf "$archive" -C "$CLIENT_DIR" "$name"; then
            echo "Backup created: $archive"
            tar -tzf "$archive" >/dev/null && echo "Archive integrity: OK"
            log_action "Backup created for $name"
        else
            echo "ERROR: Backup failed."
            log_action "Backup failed for $name"
        fi
    fi
    pause_screen
}

package_management() {
    clear
    echo "========== PACKAGE MANAGEMENT =========="
    echo "Package status:"
    for package in openssh-server cron lvm2 tar; do
        if dpkg -s "$package" >/dev/null 2>&1; then
            echo "$package: installed"
        else
            echo "$package: not installed"
        fi
    done
    echo
    echo "Install missing packages with:"
    echo "sudo apt install openssh-server cron lvm2 tar"
    pause_screen
}

server_monitoring() {
    clear
    echo "========== SERVER MONITORING =========="
    echo "--- Hostname and uptime ---"
    hostname
    uptime
    echo
    echo "--- Memory ---"
    free -h
    echo
    echo "--- Filesystem ---"
    df -h
    echo
    echo "--- CPU information ---"
    nproc
    echo
    echo "--- Recent system errors ---"
    sudo journalctl -p err -n 5 --no-pager
    pause_screen
}

security_management() {
    clear
    echo "========== SSH AND SECURITY =========="
    echo "--- Current user ---"
    whoami
    echo
    echo "--- SSH service ---"
    systemctl is-active ssh || true
    echo
    echo "--- SSH listening sockets ---"
    sudo ss -tlnp | grep ':22 ' || echo "SSH port 22 not listening"
    echo
    echo "--- Client directory permissions ---"
    ls -ld "$CLIENT_DIR"
    echo
    echo "Review users with: cut -d: -f1 /etc/passwd"
    echo "Review firewall with: sudo ufw status"
    pause_screen
}

automation_management() {
    clear
    echo "========== AUTOMATION MANAGEMENT =========="
    echo "--- Cron service ---"
    systemctl is-active cron || true
    echo
    echo "--- Current user's scheduled jobs ---"
    crontab -l 2>/dev/null || echo "No user cron jobs configured."
    echo
    echo "Edit scheduled jobs with: crontab -e"
    pause_screen
}

view_logs() {
    clear
    echo "========== SYSTEM LOG =========="
    if [[ -f "$LOG_FILE" ]]; then
        tail -n 50 "$LOG_FILE"
    else
        echo "No application logs available."
    fi
    pause_screen
}

main_menu() {
    while true; do
        clear
        echo "========================================"
        echo "       CLOUD SERVICE PROVIDER"
        echo "========================================"
        echo "Server: $(hostname) | User: $(whoami)"
        echo "1. Client Management"
        echo "2. Storage and LVM"
        echo "3. Backup and Recovery"
        echo "4. Package Management"
        echo "5. Server Monitoring"
        echo "6. SSH and Security"
        echo "7. Automation Management"
        echo "8. View System Logs"
        echo "9. Exit"
        echo "========================================"

        read -rp "Enter choice [1-9]: " choice

        case "$choice" in
            1) client_management ;;
            2) storage_management ;;
            3) backup_management ;;
            4) package_management ;;
            5) server_monitoring ;;
            6) security_management ;;
            7) automation_management ;;
            8) view_logs ;;
            9) echo "Exiting."; exit 0 ;;
            *) echo "ERROR: Invalid choice."; pause_screen ;;
        esac
    done
}

main_menu
