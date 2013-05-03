define backup (
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
) {

	# Class variables
	# ==========================================================================

	$project_path = "${local_websites_dir}/${project_name}"

	# Website deployment and configuration
	# ==========================================================================

	if ! defined( File["/data/puppet/pre-backup"] ) {
		file { "/data/puppet/pre-backup":
			ensure => "directory",
			owner => "root",
			group => "root",
			mode => "0700",
		}
	}

	if ! defined( File["/data/puppet/pre-backup/pre-backup.sh"] ) {
		file { "/data/puppet/pre-backup/pre-backup.sh":
			ensure => "present",
			source => "puppet:///modules/backup/pre-backup.sh",
			owner => "root",
			group => "root",
			mode => "0700",
		}
	}

	if ! defined( File["/data/puppet/backup"] ) {
		file { "/data/puppet/backup":
			ensure => "present",
			source => "puppet:///modules/backup/backup", # The 'files' dir is omitted
			recurse => true, # Transfer directory files too
			purge => true, # Remove client files not found on puppetmaster dir
			force => true, # Remove client dirs not found on puppetmaster dir
			owner => "root",
			group => "root",
			mode => "0700",
			require => [
				File["/data/puppet"],
			],
		}
	}

	cron { "${project_name}-backup-cron":
		command => "/data/puppet/pre-backup/pre-backup.sh -p ${project_path}; /data/puppet/backup/roundrobinbackup.py ${project_path}/ ${backup_user}@${backup_remote_server}:${backup_remote_dir}/${project_name}/backup --ssh-port ${backup_remote_ssh_port} --ssh-identity-file /home/${backup_user}/.ssh/${backup_remote_server} --days ${backup_days} --weeks ${backup_weeks} --months ${backup_months} --years ${backup_years} --exclude .git*",
		user => root,
		minute => $backup_cron_minute,
		hour => $backup_cron_hour,
		weekday => $backup_cron_weekday,
		monthday => $backup_cron_monthday,
		month => $backup_cron_month,
		require => [
			File["/data/puppet/backup"],
		],
	}

}
