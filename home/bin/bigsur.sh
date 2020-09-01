#!/usr/bin/env bash
#
# Arquivo: bigsur.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 01/09/2020 00:23:51
# Última alteração: 01/09/2020 00:23:55
#
# Uso: curl -s -L https://git.io/JUmcc | bash

TEMA="default" # default, green, red

for app in curl dialog
do
    if ! command -v $app >/dev/null;
    then 
        echo "$app não instalado. Instale primeiro."
        exit
    fi
done

[ -f /tmp/bigsur.log ] && rm /tmp/bigsur.log

certeza= ; resposta=

OLDPWD="$(pwd)"

# wallpapers=(
#     "https://i.imgur.com/M4Q0Cg1.jpg"
#     "https://i.imgur.com/mEiH3Jp.jpg"
#     "https://i.imgur.com/I9l5neF.jpg"
#     "https://i.imgur.com/LW3ieVP.jpg"
#     "https://i.imgur.com/FilQLU8.jpg"
#     "https://i.imgur.com/vRisKbd.jpg"
#     "https://i.imgur.com/viASiOi.jpg"
#     "https://i.imgur.com/3MswHfK.jpg"
#     "https://i.imgur.com/uwJYbFF.jpg"
#     "https://i.imgur.com/K36MOW7.jpg"
# )

wallpapers=(
    "https://www.dropbox.com/s/arz30b4dqdbyk11/macOS-Big-Sur-Daylight-2.jpg?dl=1"
    "https://www.dropbox.com/s/qvenoxkdjr27mmg/macOS-Big-Sur-Daylight-3.jpg?dl=1"
    "https://www.dropbox.com/s/ns2y9wlwjpxm5hr/macOS-Big-Sur-Daylight-4.jpg?dl=1"
    "https://www.dropbox.com/s/3jcptkndxlvtif4/macOS-Big-Sur-Daylight-5.jpg?dl=1"
    "https://www.dropbox.com/s/8yq2apejb8xhanq/macOS-Big-Sur-Daylight-6.jpg?dl=1"
    "https://www.dropbox.com/s/kccg04gfgkuzy0y/macOS-Big-Sur-Daylight-7.jpg?dl=1"
    "https://www.dropbox.com/s/megixou6n28e12s/macOS-Big-Sur-Daylight-8.jpg?dl=1"
    "https://www.dropbox.com/s/e7eswv7h25oaemd/macOS-Big-Sur-Daylight.jpg?dl=1"
    "https://www.dropbox.com/s/z49u8969dbhfzpc/macOS-Big-Sur-Vector-Wave-Dark.jpg?dl=1"
    "https://www.dropbox.com/s/1ez177urj6wse7s/macOS-Big-Sur-Vector-Wave.jpg?dl=1"
)

[ ! -f /tmp/${TEMA}.cfg ] && curl -s -L -o /tmp/${TEMA}.cfg https://raw.githubusercontent.com/sistematico/majestic/master/dialog/.local/share/dialog/themes/${TEMA}.cfg
export DIALOGRC=/tmp/${TEMA}.cfg

dialog                                            \
        --title 'Big Sur'                             \
        --msgbox 'Bem vindo ao script de instalação do tema Big Sur para Linux!\n\nEste script foi criado por Lucas Saliés Brum a.k.a. sistematico'  \
        0 0

parabens() {
    dialog                                            \
        --title 'Parabéns'                             \
        --msgbox 'Instalação finalizada com sucesso.'  \
        0 0
    clear
    break
}

certeza() {
    certeza=$(dialog --stdout                             \
                --title 'AVISO'                              \
                --yesno '\nTem certeza?\n\n'    \
    0 0)
}

download() {
    case "$1" in
        'temas')
            [ ! -f /tmp/bigsur.tar.xz ] && curl -s -L -o /tmp/bigsur.tar.xz 'https://www.dropbox.com/s/k2pm01az9fqs0sc/bigsur.tar.xz?dl=1'
            [ ! -d /tmp/bigsur ] && tar xJf /tmp/bigsur.tar.xz -C /tmp/
        ;;
        'wallpapers')
            [ ! -d /tmp/bigsur/wallpapers ] && mkdir -p /tmp/bigsur/wallpapers
            cd /tmp/bigsur/wallpapers
            i=0
            perc=0
            total=${#wallpapers[@]}

            (
                for wallpaper in "${wallpapers[@]}"
            do
                ((i=i+1))
                arquivo=$(basename ${wallpaper::${#wallpaper}-5})
                [ ! -f /tmp/bigsur/wallpapers/$arquivo ] && curl -s -L -J -O "$wallpaper"
                echo $((total*i))
            done
            ) | dialog --title "Baixando..." --gauge "Por favor aguarde..." 0 0 0

            cd "$OLDPWD"
        ;;
    esac
}

dialog_gtk() {
    while : ; do
        respostainstalargtk=$(dialog --stdout          \
                --title 'Big Sur GTK'               \
                --menu 'Qual tema GTK deseja usar?' \
                0 0 0                               \
                1 'Big Sur Light'                   \
                2 'Big Sur Dark'                    \
                0 'Voltar')

        [ $? -ne 0 ] && break

        case "$respostainstalargtk" in
            1) gsettings set org.gnome.desktop.interface gtk-theme 'BigSur-Light' && break ;;
            2) gsettings set org.gnome.desktop.interface gtk-theme 'BigSur-Dark' && break ;;
            0) break ;;
        esac
    done
}

dialog_shell() {
    while : ; do
        respostainstalarshell=$(dialog --stdout       \
                --title 'Big Sur Shell'               \
                --menu 'Qual tema Shell deseja usar?' \
                0 0 0                                 \
                1 'Big Sur Light'                     \
                2 'Big Sur Dark'                      \
                0 'Voltar')

        [ $? -ne 0 ] && break

        case "$respostainstalarshell" in
            1) gsettings set org.gnome.desktop.wm.preferences theme 'BigSur-Light' && killall -3 gnome-shell && break ;;
            2) gsettings set org.gnome.desktop.wm.preferences theme 'BigSur-Dark' && killall -3 gnome-shell && break ;;
            0) break ;;
        esac
    done
}

dialog_icons() {
    while : ; do
        respostainstalargtk=$(dialog --stdout          \
                --title 'Big Sur Icons'               \
                --menu 'Qual tema de ícones deseja usar?' \
                0 0 0                               \
                1 'Big Sur'                         \
                2 'Big Sur Night'                   \
                3 'Big Sur Transparent'             \
                0 'Voltar')

        [ $? -ne 0 ] && break

        case "$respostainstalar" in
            1) gsettings set org.gnome.desktop.interface icon-theme 'BigSur' && break ;;
            2) gsettings set org.gnome.desktop.interface icon-theme 'BigSur-Night' && break ;;
            3) gsettings set org.gnome.desktop.interface icon-theme 'BigSur-Transparent' && break ;;
            0) break ;;
        esac
    done
}

dialog_wallpapers() {
    let indice=0
    arquivos=() # define working array
    while read -r linha; do # process file by file
        let indice=$indice+1
        arquivos+=($indice "$linha")
    done < <( ls -1 $HOME/.local/share/wallpapers/BigSur/ )

    arquivo=$(dialog --stdout --title "Big Sur WallPapers" --menu "Escolha um wallpaper" 0 0 0 "${arquivos[@]}" 3>&2 2>&1 1>&3)

    [ $? -ne 0 ] || [ $arquivo -eq 0 ] && break
    
    gsettings set org.gnome.desktop.background picture-uri "file://$arquivo"

}

instalar() {
    case "$1" in
        'gtk')
            download 'temas'
            [ ! -d $HOME/.themes ] && mkdir -p $HOME/.themes
            cp -r /tmp/bigsur/gtk/* $HOME/.themes/
            dialog_gtk
        ;;
        'shell')
            download 'temas'
            [ ! -d $HOME/.themes ] && mkdir -p $HOME/.themes
            cp -r /tmp/bigsur/gtk/* $HOME/.themes/
            dialog_shell
        ;;
        'icons')
            download 'temas'
            [ ! -d $HOME/.icons ] && mkdir -p $HOME/.icons/
            cp -r /tmp/bigsur/icons/* $HOME/.icons/
            dialog_icons
        ;;
        'cursor')
            download 'temas'
            [ ! -d $HOME/.icons ] && mkdir -p $HOME/.icons
            cp -r /tmp/bigsur/cursor $HOME/.icons/BigSur-Cursor
            gsettings set org.gnome.desktop.interface cursor-theme 'BigSur-Cursor'
        ;;
        'wallpapers') 
            download 'wallpapers'
            [ ! -d $HOME/.local/share/wallpapers/BigSur ] && mkdir -p $HOME/.local/share/wallpapers/BigSur
            cp -r /tmp/bigsur/wallpapers/* $HOME/.local/share/wallpapers/BigSur
            gsettings set org.gnome.desktop.background picture-options 'zoom'
            #gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/wallpapers/BigSur/BigSur.jpg"
            dialog_wallpapers
        ;;
    esac
}

remover() {
    case "$1" in
        'gtk')
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
            gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
            [ -d $HOME/.themes/BigSur ] && rm -rf $HOME/.themes/BigSur*
        ;;
        'icons') 
            gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
            [ -d $HOME/.icons/BigSur ] && rm -rf $HOME/.icons/BigSur*
        ;;
        'cursor') 
            gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
            [ -d $HOME/.icons/BigSur-Cursor ] && rm -rf $HOME/.icons/BigSur-Cursor
        ;;
        'wallpapers') 
            gsettings set org.gnome.desktop.background picture-options 'zoom'
            gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/themes/Adwaita/backgrounds/adwaita-timed.xml'
            [ -d $HOME/.local/share/wallpapers/BigSur ] && rm -rf $HOME/.local/share/wallpapers/BigSur
        ;;
        'all')
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
            gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
            gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
            gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
            [ -d $HOME/.local/share/wallpapers/BigSur ] && rm -rf $HOME/.local/share/wallpapers/BigSur
            [ -d $HOME/.icons/BigSur-Cursor ] && rm -rf $HOME/.icons/BigSur-Cursor
            [ -d $HOME/.icons/BigSur ] && rm -rf $HOME/.icons/BigSur*
            [ -d $HOME/.themes/BigSur-Light ] && rm -rf $HOME/.themes/BigSur-*
        ;;
    esac
}

dialog_instalar() {
    while : ; do
        respostainstalar=$(dialog --stdout          \
                --title 'Big Sur Themes'            \
                --menu 'O que deseja instalar?'     \
                0 0 0                               \
                1 'Tema GTK'                        \
                2 'Tema Shell'                      \
                3 'Tema de Ícones'                  \
                4 'Tema de Cursor'                  \
                5 'Wallpapers'                      \
                6 'Tudo'                            \
                0 'Voltar')

        [ $? -ne 0 ] && break

        case "$respostainstalar" in
            1) instalar 'gtk' ;;
            2) instalar 'shell' ;;
            3) instalar 'icons' ;;
            4) instalar 'cursor' ;;
            5) instalar 'wallpapers' ;;
            6) instalar 'all' ;;
            0) break ;;
        esac
    done
}

dialog_remover() {
    while : ; do
        respostaremover=$(dialog --stdout           \
                --title 'Remover Tema Big Sur'      \
                --menu 'O que deseja remover?'      \
                0 0 0                               \
                1 'Tema GTK+Shell'                  \
                2 'Tema de Ícones'                  \
                3 'Tema de Cursor'                  \
                4 'Wallpapers'                      \
                5 'Tudo'                            \
                0 'Voltar')

        [ $? -ne 0 ] && break

        case "$respostaremover" in
            1) remover 'gtk' ;;
            2) remover 'icons' ;;
            3) remover 'cursor' ;;
            4) remover 'wallpapers' ;;
            5) remover 'all' ;;
            0) break ;;
        esac
    done
}

principal() {
    while : ; do
        respostaprincipal=$(dialog --stdout         \
                --title 'Big Sur'                   \
                --menu 'O que deseja fazer?'        \
                0 0 0                               \
                1 'Instalar'                        \
                2 'Remover'                         \
                0 'Sair')

        [ $? -ne 0 ] && break

        case "$respostaprincipal" in
            1) dialog_instalar ;;
            2) dialog_remover ;;
            0) break ;;
        esac
    done

    clear
}

principal
