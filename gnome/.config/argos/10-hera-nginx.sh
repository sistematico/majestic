#!/usr/bin/env bash

echo "👾️"
echo "---"
echo "⬇️ down | terminal=true bash='rm -rf /tmp/sites/ && scp -r root@hera:/etc/nginx/sites/ /tmp/'"
echo "⬆️ up | terminal=true bash='rm -rf /tmp/sites/ && scp /tmp/sites/* root@hera:/etc/nginx/sites/'"
echo "💣️ Reiniciar | terminal=false bash='ssh root@hera \"systemctl restart nginx\"'"
echo "✍️ Editar | bash='gedit /tmp/sites/*' terminal=false"

