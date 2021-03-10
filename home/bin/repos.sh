#!/usr/bin/env bash
# Source: https://stackoverflow.com/a/32833411

#[ $# -lt 2 ] && echo "Número incorreto de parâmetros" && exit

if [ $# -lt 3 ]; then
    pagina=1
else
    pagina=$3
fi

if [ "$1" == "github" ]; then
    # Github
    curl "https://api.github.com/users/$NAME/repos?page=$pagina&per_page=100" |
        grep -e 'git_url*' |
        cut -d \" -f 4
else
    # Gitlab
    id="$(curl -s https://gitlab.com/api/v4/users?username=$2 | grep -o "\"id\":[^ ,]\+" | xargs -L1 basename | awk -F ':' '{print $2}')"
    #projeto="$(curl -s https://gitlab.com/api/v4/users/${id}/projects | grep -o "\"ssh_url_to_repo\":[^ ,]\+" | xargs -L1 basename | awk -F ':' '{print $2}')"
    #projeto="$(curl -s https://gitlab.com/api/v4/users/${id}/projects | grep -o "\"ssh_url_to_repo\":[^ ,]\+" | xargs -L1 basename)"
    projeto="$(curl -s https://gitlab.com/api/v4/users/${id}/projects | grep -o "\"ssh_url_to_repo\":[^ ,]\+" | awk -F ':' '{print $2}')"

    echo $projeto

    # Projetos: https://gitlab.com/api/v4/users/[id]/projects
    #TOKEN="PASTE_YOUR_PRIVATE_TOKEN_HERE";

    # ssh_url_to_repo / http_url_to_repo



    ######PREFIX="ssh_url_to_repo";
    #curl --header "PRIVATE-TOKEN: $TOKEN" http://gitlab.com/api/v3/projects | grep -o "\"$PREFIX\":[^ ,]\+" | xargs -L1 basename | awk -F '.' '{print $1}'
    ######curl http://gitlab.com/api/v3/projects | grep -o "\"$PREFIX\":[^ ,]\+" | xargs -L1 basename | awk -F '.' '{print $1}'
fi

#curl https://gitlab.com/api/v4/users?username=sistematico | grep -e 'id:*' | cut -d \" -f 3
