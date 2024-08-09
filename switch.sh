
# check if .back folder exists 
# if it does just append the current date to the folder name

# mv ~/.local/share/nvim $(date +%Y%m%d)
DATE=$(date +%Y%m%d)
mv ~/.local/share/nvim{,.bak_$DATE}
mv ~/.local/state/nvim{,.bak_$DATE}
mv ~/.cache/nvim{,.bak_$DATE}


# mv ~/.local/share/nvim{,.bak}
# mv ~/.local/state/nvim{,.bak}
# mv ~/.cache/nvim{,.bak}


