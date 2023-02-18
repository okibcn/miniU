# install zsh
sudo apt install zsh zsh-syntax-highlighting

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# oh-my-posh Themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# place this in .bashrc or .zshrc
echo "eval \"\$(oh-my-posh init \$(oh-my-posh get shell))\"" >> ~/.bashrc
echo "eval \"\$(oh-my-posh init \$(oh-my-posh get shell))\"" >> ~/.zshrc

cp Github_linux/.nanorc    ~/.nanorc
cp Github_linux/profile.sh ~/.bashrc
cp Github_linux/profile.sh ~/.zshrc
