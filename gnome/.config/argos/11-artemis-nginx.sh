#!/usr/bin/env bash

echo "👾️"
echo "---"
echo "⬇️ down | terminal=true bash='rm -rf /tmp/sites/ && scp -r root@artemis:/etc/nginx/sites/ /tmp/'"
echo "⬆️ up | terminal=true bash='scp /tmp/sites/* root@artemis:/etc/nginx/sites/'"
echo "💣️ Reiniciar | terminal=false bash='ssh root@artemis \"systemctl restart nginx\"'"
echo "✍️ Editar | bash='gedit /tmp/sites/*' terminal=false"

