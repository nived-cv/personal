# set file to executable before executing
# execute by ./install.sh
user=$(whoami)
gitEmail=$(git config user.email)
sed -i "s/nived.cv@vonnue.com/$gitEmail/" "stats.sh"
sed -i "s/nived/$user/" "stats.sh"

mkdir ~/bin/
cp 'stats.sh' ~/bin/
cp 'lookup.csv' ~/bin/

echo "alias stats='stats.sh'" >> ~/.bashrc
echo "export PATH="'$PATH:/home/'"$user"'/bin' >> ~/.bashrc
cd ~/bin/
chmod +x stats.sh

echo "---------finished----------"
