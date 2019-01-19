SSHD_FILE=/etc/ssh/sshd_config

$INSTALL openssh-server
sudo service ssh --full-restart
