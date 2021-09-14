cd $HOME
wget https://get.helm.sh/helm-v3.2.0-linux-amd64.tar.gz
tar -zxvf helm-v3.2.0-linux-amd64.tar.gz
echo 'export PATH=$HOME/linux-amd64:$PATH' > $HOME/.bash_profile
source $HOME/.bash_profile