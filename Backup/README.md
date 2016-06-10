This backup script tries to achieve Time Machine-like functionality using rsync

It is meant to be run by an hourly cronjob

Backups in the backup directory will be named in the form of "YYYY-MM-DD-HHMMSS", with "current" always being a symlink to the latest backup
