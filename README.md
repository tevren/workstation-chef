# workstation-chef
Sets up my developer workstation with homebrew/ruby/mysql/IntelliJ/git repos.

##  Step 1: Setup your ssh keys:

* Run ssh-keygen to create key pair:
```
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
ssh-keygen -b 2048
```

* Copy contents of id_rsa.pub
```
pbcopy < ~/.ssh/id_rsa.pub  # OR open file, select all text and copy to clipboard
```

* Add key to your Github/Bitbucket account
  * This is required if you have repos you'd like to checkout during setup. 

## Step 2: Install xcode-tools and chef

* Your password will be required when installing xcode-tools (At the very beginning)
```
curl -L https://raw.githubusercontent.com/tevren/workstation-chef/master/bootstrap.sh | bash
```

## Step 3: Clone this repo
```
git clone git@github.com:tevren/workstation-chef.git
cd workstation-chef
git submodule update --init
```

## Step 4: Customize

* Edit data_bags/apps/workstation.json to install the brews/apps/dmgs/git_repos that you'd like
* Edit data_bags/apps/user.json to set your shell.
* Edit roles/mac_os_x.json to change your osx settings. 
* You probably want to remove recipe[workstation::user] from the run list in roles/workstation.json unless you want my dotfiles (:

## Step 5: Let it rip!

* Your password will be required in various stages (listed below)

  * When install java via Chef (fairly early on in the chef-run)
  * When installing your first app (towards the middle of the chef-run)

* Runs chef, which will install all the other components (ruby/mysql/android-tools)
```
./go
```
## How long does it take?

It took my puny vm an hour to converge my setup.
```
Chef Client finished, 218/293 resources updated in 3803.392194 seconds
```