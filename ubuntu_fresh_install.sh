#!/bin/sh
clear
echo "Hi, this script aims to be run on a fresh installed version of ubuntu, providing tools for java and ruby developers."
echo ""

user=$USER
tools_dir="$HOME/tools"

ask_to_install (){
	while true; do
			echo "";
		  read -p "Do you wish to install $1?" yn
		  case $yn in
		      [Yy]* ) echo "installing $1..."; $2; echo "done!";  echo ""; break;;
		      [Nn]* ) echo "$1 skipped!"; echo ""; break;;
		      * ) echo "Please answer yes or no.";;
		  esac
	done
}

goto_tools_dir () {
  mkdir $tools_dir
  cd $tools_dir
}

install_gnome_do () {
  sudo apt-get install gnome-do gnome-do-plugins
  sudo add-apt-repository ppa:docky-core/ppa
  sudo apt-get update
  sudo apt-get install docky
}

install_java () {
  sudo apt-get install sun-java6-jdk sun-java6-jre
}

install_eclipse () {
  goto_tools_dir
  wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/helios/SR2/eclipse-jee-helios-SR2-linux-gtk.tar.gz
  tar -xzvf eclipse-jee-helios-SR2-linux-gtk.tar.gz
}

install_postgres () {
  sudo add-apt-repository ppa:pitti/postgresql
  sudo apt-get update
  sudo apt-get install postgresql libpq-dev
  sudo passwd -d postgres
  sudo su postgres -c passwd
  sudo apt-get install pgadmin3
}

install_sqlite () {
  sudo apt-get install sqlite3 libsqlite3-dev
}

install_mysql () {
  sudo apt-get install mysql-client mysql-server libmysqlclient-dev
}

install_ubuntu_dev_requirements () {
  sudo apt-get install build-essential subversion curl python-software-properties vim gvim
  sudo apt-get install bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libcurl4-openssl-dev
}

install_git () {
  sudo apt-get install git git-doc gitg
  read -p "Inform your git name (example: John Doe):" gitname
  read -p "Inform your git email (example: johndoe@example.com):" gitmail
  git config --global user.name $gitname
  git config --global user.email $gitmail
  git config --global core.editor gvim
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.branch auto
  git config --global color.status.changed yellow
  git config --global color.status.added green
  git config --global color.status.untracked red
  echo "Generating SSH keys... Provide a good passphrase when asked!"
  ssh-keygen -t rsa -C $gitmail
}

install_utilities () {
  echo "installing nautilus-open-terminal plugin..."
  sudo apt-get install nautilus-open-terminal
  nautilus -q

  echo "installing system monitoring tool htop..."
  sudo apt-get install htop

  echo "installing color picker GColor2..."
  sudo apt-get install gcolor2

  echo "installing ScreenRuler"
  sudo apt-get install screenruler

  echo "installing GMate - gedit plugin set"
  sudo add-apt-repository ppa:ubuntu-on-rails/ppa
  sudo apt-get update
  sudo apt-get install gedit-gmate
}

install_rvm () {
  echo "installing ruby..."
  sudo apt-get install irb libopenssl-ruby libreadline-ruby rdoc ri ruby ruby-dev
  echo "installing RubyGems..."
  goto_tools_dir
  wget http://production.cf.rubygems.org/rubygems/rubygems-1.6.2.tgz
  tar -xzvf rubygems-1.6.2.tgz
  cd rubygems-1.6.2
  sudo ruby setup.rb
  sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.8 1
  echo "install: --no-ri --no-rdoc" >> ~/.gemrc
  echo "update: --no-ri --no-rdoc" >> ~/.gemrc
  #bash < <(curl -B http://rvm.beginrescueend.com/install/rvm)
  #echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
  #echo '[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion' >> ~/.bashrc
  #source ~/.rvm/scripts/rvm
  #echo "Verifying RVM installation..."
  #rvm -v
  #rvm install 1.8.7
  #rvm install 1.9.2
  #rvm --default 1.9.2
  echo "# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
  echo "#                                                                               #"
  echo "#   NOTE: RVM install could be a little tricky... =/                            #"
  echo "#                                                                               #"
  echo "#   if the last command have failed, please follow instructions in this page:   #"
  echo "#      http://rvm.beginrescueend.com/rvm/install/                               #"
  echo "#                                                                               #"
  echo "# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
}

######################## actual installation calls start here! =P #################################

echo "Adding apt-get Canonical Partner repository for Ubuntu Maverick (10.10)..."
sudo add-apt-repository "deb http://archive.canonical.com/ maverick partner"

echo "updating apt-get repositories..."
sudo apt-get update

ask_to_install "Utilities (recomended!)" install_utilities

echo "installing common dev requirements..."
install_ubuntu_dev_requirements

ask_to_install "Gnome Do with Docky (http://do.davebsd.com)" install_gnome_do
ask_to_install "Java JDK & JRE" install_java
ask_to_install "Eclipse IDE" install_eclipse
ask_to_install "PostgreSQL & pgAdmin3" install_postgres
ask_to_install "SQLite" install_sqlite
ask_to_install "MySql" install_mysql
ask_to_install "Git" install_git
ask_to_install "RVM - Ruby Version Manager" install_rvm

echo "------------------------------------------------------"
echo "- You are done and ready to go!"
echo "------------------------------------------------------"

