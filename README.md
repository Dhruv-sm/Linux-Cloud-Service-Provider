# Linux-Cloud-Service-Provider
Linux-based Cloud Storage Management and Monitoring System using Bash, LVM and Linux Administration tools
# Linux Cloud Service Provider – Storage Management System

## Project Overview

The Linux Cloud Service Provider – Storage Management System is a Bash-based project designed to simulate basic cloud storage administration using Linux system administration tools.

The system provides a menu-driven interface that allows an administrator to manage client storage, monitor system resources, perform backups, and manage essential server services.

## Objectives

- Implement a menu-driven Linux administration system using Bash scripting.
- Manage storage using Logical Volume Management (LVM).
- Organize and manage client storage directories.
- Automate backup operations.
- Monitor system performance and resource utilization.
- Manage essential Linux services and packages.

## Technologies Used

| Technology | Purpose |
|---|---|
| Ubuntu Linux | Operating system |
| Bash Shell Scripting | Application development |
| LVM | Logical storage management |
| ext4 | Filesystem |
| tar | Backup and archive management |
| cron | Scheduled automation |
| SSH | Remote server access |
| systemctl | Service management |
| journalctl | System log monitoring |

## Project Structure

```text
cloud-service-provider/
│
├── scripts/
│   ├── cloud_manager.sh
│   └── auto_backup.sh
│
├── data/
│   └── clients.txt
│
├── backups/
│
├── logs/
│
└── reports/
```

## Key Features

### 1. Client Management
- Manage client-related storage directories.
- Organize client data within the storage environment.
- Apply directory permissions for access control.

### 2. Storage Management
- Configure physical volumes, volume groups, and logical volumes using LVM.
- Create and manage logical storage.
- Format and mount storage using the ext4 filesystem.

### 3. Backup and Recovery
- Create compressed backups using `tar`.
- Automate backup operations using cron.
- Verify backup archive integrity.

### 4. System Monitoring
- Monitor memory utilization, disk usage, and system uptime.
- Inspect system resource information.
- Monitor system logs using journalctl.

### 5. Package and Service Management
- Check and manage required Linux packages.
- Monitor SSH and cron services.
- Use systemctl for service administration.

## Storage Architecture

The project uses Logical Volume Management (LVM) to provide flexible storage allocation.

The storage architecture consists of:

- Physical Volume (PV)
- Volume Group (VG)
- Logical Volume (LV)
- ext4 filesystem
- Mounted storage directory

The configured storage is mounted at:

`/srv/cloud-storage`

## How to Run

1. Open the Ubuntu Linux terminal.
2. Navigate to the project directory:

```bash
cd ~/cloud-service-provider
```

3. Make the scripts executable:

```bash
chmod +x scripts/*.sh
```

4. Run the main application:

```bash
sudo ./scripts/cloud_manager.sh
```

## Learning Outcomes

- Practical understanding of Linux system administration.
- Experience with Bash scripting and automation.
- Understanding of LVM-based storage management.
- Experience with Linux permissions and service management.
- Knowledge of backup and recovery operations.
- Practical exposure to Linux monitoring tools.

## Project Information

**Project Title:** Linux Cloud Service Provider – Storage Management System

**Platform:** Ubuntu Linux

**Implementation Language:** Bash Shell Scripting

**Repository:** Linux-Cloud-Service-Provider
