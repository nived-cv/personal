# set file to executable before executing
# execute by ./install.sh
user=$(whoami)
sed -i "s/nived/$user/" "stats.sh"

mkdir ~/bin/
cp 'stats.sh' ~/bin/
cp 'lookup.csv' ~/bin/

echo "alias stats='stats.sh'" >> ~/.bashrc
echo "export PATH="'$PATH:/home/'"$user"'/bin' >> ~/.bashrc
cd ~/bin/
chmod +x stats.sh

echo "---------finished----------"