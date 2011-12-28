#list of users that will have the s3cmd configuration 
default[:s3cmd][:users] = ["root"]
default[:s3cmd][:bucket_location] = "southeast-1"
default[:s3cmd][:delete_removed] = "True"
default[:s3cmd][:use_https] = "True"
default[:s3cmd][:bucket_name] = "kirra.restracker.com"
default[:s3cmd][:backup_directory] = "/var/backups/mysql" # include trailing / if you want to skip copying the directory itself