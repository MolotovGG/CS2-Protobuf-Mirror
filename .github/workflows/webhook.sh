DIFF="$(git --no-pager diff --stat HEAD~1 HEAD -- ./protobufs/)"
THIS_COMMIT="$(git rev-parse HEAD)"
TRACKED_HASH_SHORT="${latest_version:0:12}"
CS_VERSION="$(cat steam.inf | grep 'PatchVersion=' | sed 's/PatchVersion=//')"
URL="https://discord.com/api/webhooks/${webhook_path}?wait=true"

printf "null" | jq \
 --arg "diff" "$DIFF"\
 --arg "this_commit" "$THIS_COMMIT"\
 --arg "tracked_commit" "$TRACKED_HASH_SHORT"\
 --arg "cs_version" "$CS_VERSION" '. |
{
  "content": null,
  "embeds": [{
    "title": "Protobuf Mirror Update",
    "description": "```\($diff)```\n[View on Github](https://github.com/MolotovGG/CS2-Protobuf-Mirror/commit/\($this_commit))",
    "color": "5831847",
    "fields": [
      {
        "name":"Hash",
        "value": $tracked_commit,
        "inline":true
      },
      {
        "name":"CS2 Version",
        "value": $cs_version,
        "inline":true
      }
    ],
    "author":{
      "name":"MolotovGG/CS2-Protobuf-Mirror",
      "url":"https://github.com/MolotovGG/CS2-Protobuf-Mirror",
      "icon_url":"https://avatars.githubusercontent.com/in/15368"
    }
  }],
  "username":"Protobot",
  "avatar_url": "https://365randommuppets.wordpress.com/wp-content/uploads/2014/03/094-80s-robot.jpg?w=1200",
  "attachments": []
}' | tee /dev/stderr | curl -H "Content-Type: application/json" -d@- "$URL" -v