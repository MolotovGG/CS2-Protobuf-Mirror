#!/bin/bash

latest_version=$(curl https://api.github.com/repos/SteamDatabase/GameTracking-CS2/commits/master | jq ".sha" -r)
current_version=$(cat ./hash.txt)

echo "Current Version: ${current_version}"
echo "Latest Version: ${latest_version}"

if [latest_version <> current_version ] then
    echo "Updating..."

    mkdir working/
    curl https://codeload.github.com/SteamDatabase/GameTracking-CS2/zip/refs/heads/master -O ./working/repo.zip
    unzip ./working/repo.zip -d ./repo/

    rm -rf ./protobufs/
    mkdir ./protobufs/
    cp ./working/repo/Protobufs/* ./protobufs/

    cat ./working/repo/game/csgo/steam.inf > ./steam.inf
    echo latest_version > ./hash.txt

    rm -rf ./working/

    git add -A
    git commit -m "Update Mirror to ${latest_version}"
    git push
fi
