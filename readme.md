About
================================================================================

A custom puppet-module for push-based round-robin automated backups of project
files and database data.

This module is a wrapper for
a [roundrobinbackup.py](https://github.com/chrislaskey/round-robin-backup.py).
It backs up project files and database data from Puppet clients on to the
Puppet Master.

Default arguments include:

	$project_name = $title,
	$local_websites_dir = "/data/websites",
	$backup_remote_server = $puppetmaster_fqdn,
	$backup_remote_dir = "/data/available-websites",
	$backup_user = "deploy",
	$backup_remote_ssh_port = "2222",
	$backup_days = '6',
	$backup_weeks = '5',
	$backup_months = '6',
	$backup_years = '20',
	$backup_cron_minute = '0',
	$backup_cron_hour = 2, # Can be individual: [2,12,15] or ranged: [2-4,10-14]
	$backup_cron_weekday = '*',
	$backup_cron_monthday = '*',
	$backup_cron_month = '*',

Backup Directory Structure
--------------------------

Project backups are stored on the puppet server in the directory
`$backup_remote_dir/$project_name`. Within this project directory the data is
stored in the following configuration:

	./backup/
	./backup/latest/
	./backup/automated-backup-2013-01-01.tar.gz
	./backup/automated-backup-2012-01-01.tar.gz

The backup `tar.gz` files are rotated based on the `$backup_*` parameter
values. See
[round-robin-backup.py](https://github.com/chrislaskey/round-robin-backup.py)
for details.

Backing up MySQL Databases
--------------------------

Also includes a `pre-backup.sh` script for creating live-data information
backups, such as MySQL database backups, before the round robin backup is run.

The `pre-backup.sh` script requires the target project directory structure to
mirror the default
[puppet-deploy](https://github.com/chrislaskey/puppet-deploy) structure.

Continuous Delivery with Puppet-Deploy
--------------------------------------

Combined with the
[puppet-deploy](https://github.com/chrislaskey/puppet-deploy), this module
provides a powerful platform for continuous delivery with full separation of
application data and application code. See the [puppet-deploy
documentation](https://github.com/chrislaskey/puppet-deploy) for details.

License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
