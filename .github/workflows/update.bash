#!/bin/bash

latest_version=$(curl https://api.github.com/repos/SteamDatabase/GameTracking-CS2/commits/master | jq ".sha" -r)
current_version=$(cat ./hash.txt)

echo "Current Version: ${current_version}"
echo "Latest Version: ${latest_version}"

if [ "$latest_version" = "null" ]; then
    echo "Null Update Version; Skipping..."
elif [ "$latest_version" != "$current_version" ]; then
    echo "Updating..."

    mkdir working/
    curl https://codeload.github.com/SteamDatabase/GameTracking-CS2/zip/refs/heads/master -o ./working/repo.zip
    unzip ./working/repo.zip -d ./working/repo/

    rm -rf ./protobufs/
    mkdir ./protobufs/
    cp ./working/repo/GameTracking-CS2-master/Protobufs/* ./protobufs/

    cat ./working/repo/GameTracking-CS2-master/game/csgo/steam.inf > ./steam.inf
    echo "${latest_version}" > ./hash.txt

    rm -rf ./working/
    
    git config user.email "bot@samh.dev"
    git config user.name "Updater"
    git add -A
    git commit -m "Update Mirror to ${latest_version:0:12}"
    git push

    echo "Update Finished; Via La Loca"
else
    echo "No Work; Goodbye"
fi
