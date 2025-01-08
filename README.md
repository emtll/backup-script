# Automatic Backup Script with Inotify
* This script automates the backup process for specified directories using rsync and monitors changes using inotifywait.
* The script's motivations were to automate the backups of the LNBits databases and at the same time Nutshell mint

# Requirements

### Ensure your system meets the following requirements:

* Linux Environment: This script is designed for Linux and Unix-like systems.
* rsync: Ensure rsync is installed. If not, install it using your package manager (for Debian/Ubuntu).
```
sudo apt install rsync
```
* inotify-tools: Install inotify-tools if not already available (for Debian/Ubuntu).
```
sudo apt install inotify-tools
```

# Installation

### Clone the Repository:

```
git clone https://github.com/emtll/backup-script.git
```

```
cd backup-script/
```

### Make the Script Executable:

```
chmod +x backup-script.sh
```

# Configuration

### Open backup-script.sh in a text editor:

```
sudo nano backup-script.sh
```

### Change Variables

* Modify the following variables to match your setup:

```
DIR_LNBITS: Path to the directory you want to backup.
DIR_CASHU: Path to another directory you want to backup.
DIR_LNBITSDATA: Path to monitor changes for the first directory.
DIR_CASHUDATA: Path to monitor changes for the second directory.
DIR_BACKUP_LOCAL_LNBITS: Local path to store backups for DIR_LNBITS.
DIR_BACKUP_LOCAL_CASHU: Local path to store backups for DIR_CASHU.
DIR_BACKUP_REMOTE_LNBITS: Remote path to store backups for DIR_LNBITS.
DIR_BACKUP_REMOTE_CASHU: Remote path to store backups for DIR_CASHU.
```

* Optionally, adjust DIRNAME_LNBITS and DIRNAME_CASHU for customized backup directory names.

# Usage

### Run the Script:

* Execute the script from the terminal:

```
./backup-script.sh
```

# Automatic Backups

* The script will monitor specified directories (DIR_LNBITSDATA and DIR_CASHUDATA) for changes using inotifywait and perform backups automatically when changes occur, subject to a minimum interval.

# Customization

* Backup Frequency: Adjust MIN_INTERVAL variable in seconds to set the minimum time between backups.
* Additional Directories: Modify the script to add more directories for backup by replicating the rsync commands in the backup() function.

# Systemd Service 

### Create a new systemd service file

```
sudo nano /etc/systemd/system/backup-script.service
```

### Copy and paste the following content:

```
[Unit]
Description=Backup Script Service

[Service]
ExecStart=/path/to/backup-script.sh
Restart=always
User=<your_user>
Environment=HOME=/home/<your_user>/

[Install]
WantedBy=multi-user.target
```

### After creating or modifying the service file, reload systemd for it to recognize the new service:

```
sudo systemctl daemon-reload
```

### Start and Enable the Service:

```
sudo systemctl start backup-script.service
```

```
sudo systemctl enable backup-script.service
```

### Check service status

```
systemctl status backup-script.service
```

### View service logs

* You can check the logs of your service using journalctl:

```
journalctl -fu backup-script.service
```

This command will display logs related to your service, allowing you to monitor its activity and troubleshoot any issues.

### Customization:

* Paths and User: Replace /home/<your_user>/ with the actual paths and voltz with the appropriate user according to your setup.
* Service Description: Update the Description field in the [Unit] section to provide a meaningful description of your service.

By following these steps, you'll have configured a systemd service to run your backup script automatically, ensuring continuous data protection for your specified directories.
