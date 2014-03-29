log_level         :info
log_location      STDOUT
current_path      File.expand_path(File.join(File.dirname(__FILE__)))
cookbook_path     "#{current_path}/cookbooks"
role_path         "#{current_path}/roles"
data_bag_path     "#{current_path}/data_bags"
file_cache_path   "/tmp/chef-solo/cache"
file_backup_path  "/tmp/chef-solo/backup"
