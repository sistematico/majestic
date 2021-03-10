
containers=($(docker ps -a | awk 'NR>1 {print $1}'))

if [ "${containers[*]" ]; then
    read -p "Tem certeza que deseja apagar os containers: ${containers[*]}? [s/N]: " resposta
else
    echo "Nenhum container."
fi

if [[ "$resposta" == "[sS]"* ]]; then
    for cont in "${containers[@]}"; do
        docker stop $cont
        docker rm $cont
    done
else
    exit
fi


imagens=($(docker images | awk 'NR>1 {print $3}'))

if [ "${imagens[*]" ]; then
    read -p "Tem certeza que deseja apagar as imagens: ${imagens[*]}? [s/N]: " resposta
else
    echo "Nenhuma imagem."
    exit
fi

if [ "${#imagens[@]}" -gt 1 ]; then
    if [[ "$resposta" == [sS]* ]]; then
        for img in "${imagens[@]}"; do
            docker rmi $img
        done
    fi
fi
