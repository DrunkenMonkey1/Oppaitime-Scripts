#! /bin/bash

backup=/var/backup
date=$(date "+%Y-%m-%d-%H%M%S")
mysqlpw="AAAAAAAAAA"

mkdir -p $backup/$date/www
rsync -ax --delete --exclude='.git*' --exclude='misc/*' --link-dest=$backup/current/www/ /var/www/ $backup/$date/www/
mysqldump --single-transaction --password="${mysqlpw}" gazelle | gzip -c > $backup/$date/gazelle.sql.gz

rm $backup/current
ln -s $backup/$date $backup/current

# One backup per day for backups older than 12 hours
hourlies=$(find $backup -maxdepth 1 -type d -mmin +720 | sort)
day=0
for i in $hourlies; do
	rday=$(echo $i | awk -F '-' '{print $3}')
	if [[ $rday = $day ]]; then
		rm -r $i
	else
		day=$rday
	fi
done

# One backup per month for backups older than two weeks
monthlies=$(find $backup -maxdepth 1 -type d -mtime +14 | sort)
month=0
for i in $monthlies; do
	rmonth=$(echo $i | awk -F '-' '{print $2}')
	if [[ $rmonth = $month ]]; then
		rm -r $i
	else
		month=$rmonth
	fi
done
