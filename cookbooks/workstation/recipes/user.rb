
begin
  u  = data_bag_item("users", "user")
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("#{cookbook_name} could not load data bag; #{e}")
end

git "#{ENV['HOME']}/.oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
  user ENV['USER']
end

bash "move_dotfiles_from_repo_into_home" do
  user ENV['USER']
  cwd "#{node['workstation']['workspace']}/dotfiles"
  code <<-EOH
  rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
    --exclude "README.md" --exclude ".osx" --exclude ".brew" --exclude ".caskfile" --exclude "install_homebrew" \
    --exclude "LICENSE-MIT.txt" -av --no-perms . #{ENV['HOME']}
  source #{ENV['HOME']}/.zshrc
  EOH
end

if !u['shell'].match(/\/bin\/bash/) && File.exists?(u['shell'])
  bash "set_shell" do
    user ENV['USER']
    cwd "/tmp"
    code <<-EOH
    echo "#{u['shell']}" |sudo tee -a /etc/shells
    chsh -s #{u['shell']} #{ENV['USER']}
    EOH
    not_if { system("sudo grep '#{u['shell']}' /etc/shells") }
  end
end
