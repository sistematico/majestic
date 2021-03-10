objects = [
    Favs = {
        links: [ 
            link1 = {name:"Lucas Brum",url:"https://lucasbrum.net"},
            link2 = {name:"Brum Informática",url:"https://bruminformatica.com.br"},
            link3 = {name:"Linux Pictures",url:"https://linux.pictures"},
            link4 = {name:"iCloud",url:"https://icloud.com/"}
        ],
        preicon:"fas",
        icon:"fa-link",
        url:"https://google.com.br/search",
        query:"?q=",
        ph:"Pesquisa Google",
        name:"favs",
        method:"post",
        color:"#555" //Not used yet
    },
    Code = {
        links: [ 
            link1 = {name:"Majestic",url:"http://majestic"},
            link2 = {name:"Basic HTML Skel",url:"https://www.taniarascia.com/basic-html5-file/"},
            link3 = {name:"DevHints",url:"https://devhints.io/"}
        ],
        preicon:"fas",
        icon:"fa-code",
        url:"https://google.com.br/search",
        query:"?q=",
        ph:"Código",
        name:"code",
        method:"post",
        color:"#555" //Not used yet
    },    
    Sheets = {
        links: [ 
            link1 = {name:"vim",url:"https://vim.rtorr.com/lang/pt_br/"},
            link2 = {name:"qutebrowser",url:"https://qutebrowser.org/img/cheatsheet-big.png"},
            link3 = {name:"ncmpcpp",url:"https://pkgbuild.com/~jelle/ncmpcpp/"}
        ],
        preicon:"fas",
        icon:"fa-stroopwafel",
        url:"https://google.com.br/search",
        query:"?q=",
        ph:"Pesquisa Google",
        name:"sheets",
        method:"post",
        color:"#555" //Not used yet
    },
    Google = {
        links: [ 
            link1 = {name:"Google",url:"https://www.google.com.br"},
            link2 = {name:"Fotos",url:"https://www.google.com/photos/"},
            link3 = {name:"Gmail",url:"https://www.google.com/gmail/"},
            link4 = {name:"Drive",url:"https://www.google.com/drive/"}, 
            link5 = {name:"Maps",url:"https://www.google.com/maps"},  
        ],
        preicon:"fab",
        icon:"fa-google",
        url:"https://google.com.br/search",
        query:"?q=",
        ph:"Pesquisa Google",
        name:"google",
        method:"post",
        color:"#555" //Not used yet
    },
    Stackoverflow = {
        links: [ 
            link1 = {name:"StackOverflow",url:"https://stackoverflow.com"},
            link2 = {name:"StackOverflow PT",url:"https://pt.stackoverflow.com"}
        ],
        preicon:"fab",
        icon:"fa-stack-overflow",
        url:"https://stackoverflow.com/search",
        query:"?q=",
        ph:"Pesquisa StackOverflow",
        name:"stackoverflow",
        method:"post",
        color:"#555" //Not used yet
    },
    Reddit = {
        links: [ 
            link1 = {name:"Reddit",url:"https://reddit.com"}, 
            link2 = {name:"Startpages",url:"https://www.reddit.com/r/startpages"},
            link3 = {name:"Unixporn",url:"https://www.reddit.com/r/unixporn/search?q=i3-gaps&restrict_sr=1&sort=new"} 
        ],
        preicon:"fab",
        icon:"fa-reddit",
        url:"https://reddit.com/r/",
        query:"",
        ph:"r/",
        name:"reddit",
        method:"post",
        color:"#555" //Not used yet
    },
    Youtube = {
        links: [ 
            link1 = {name:"Youtube",url:"https://www.youtube.com"}, 
            link2 = {name:"Inscrições",url:"https://www.youtube.com/feed/subscriptions"},
            link3 = {name:"Playlist",url:"https://www.youtube.com/playlist?list=WL&disable_polymer=true"}
        ],
        preicon:"fab",
        icon:"fa-youtube",
        url:"https://www.youtube.com/results",
        query:"?search_query=",
        ph:"Pesquisa Youtube",
        name:"youtube",
        method:"post",
        color:"#555" //Not used yet
    },
    Twitch = {
        links: [ 
            link1 = {name:"Twitch",url:"https://www.twitch.tv/"}, 
            link2 = {name:"Seguindo",url:"https://www.twitch.tv/directory/following"}, 
        ],
        preicon:"fab",
        icon:"fa-twitch",
        url:"https://www.twitch.tv/",
        query:"",
        ph:"Canal",
        name:"twitch",
        method:"post",
        color:"#555" //Not used yet
    },
    Twitter = {
        links: [ 
            link1 = {name:"Twitter",url:"https://www.twitter.com/"}
        ],
        preicon:"fab",
        icon:"fa-twitter",
        url:"https://www.facebook.com/search/str/",
        query:"",
        ph:"Pesquisa Twitter",
        name:"twitter",
        method:"post",
        color:"#555" //Not used yet
    },    
    Facebook = {
        links: [ 
            link1 = {name:"Facebook",url:"https://www.facebook.com/"}, 
            link2 = {name:"Messenger",url:"https://www.messenger.com/"},  
        ],
        preicon:"fab",
        icon:"fa-facebook",
        //url:"https://facebook.com/search?",
        url:"https://www.facebook.com/search/str/",
        query:"",
        ph:"Pesquisa Facebook",
        name:"facebook",
        method:"post",
        color:"#555" //Not used yet
    },
    Github = {
        links: [ 
            link1 = {name:"Github",url:"https://github.com/"},  
            link2 = {name:"Sistematico",url:"https://github.com/sistematico"},
            link3 = {name:"Arch Linux BR Dev",url:"https://github.com/archlinux-br-dev"},
        ],
        preicon:"fab",
        icon:"fa-github-alt",
        url:"https://github.com/search",
        query:"?q=",
        ph:"Pesquisa Github",
        name:"github",
        method:"post",
        color:"#555" //Not used yet
    },
    Gitlab = {
        links: [ 
            link1 = {name:"Gitlab",url:"https://gitlab.com"}, 
            link2 = {name:"Sistematico",url:"https://gitlab.com/sistematico"}, 
        ],
        preicon:"fab",
        icon:"fa-gitlab",
        url:"https://github.com/search",
        query:"?q=",
        ph:"Pesquisa Gitlab",
        name:"gitlab",
        method:"post",
        color:"#555" //Not used yet
    },
    Archwiki = {
        links: [ 
            link1 = {name:"Arch Wiki",url:"https://wiki.archlinux.org"}, 
        ],
        preicon:"fab",
        icon:"fa-linux",
        url:"https://wiki.archlinux.org/index.php",
        query:"?search=",
        ph:"Arch Wiki",
        name:"archwiki",
        method:"post",
        color:"#555" //Not used yet
    },
    Wikipedia = {
        links: [ 
            link1 = {name:"Wikipedia",url:"https://pt.wikipedia.org"}, 
            link2 = {name:"Neste Dia",url:"https://pt.wikipedia.org/wiki/Portal:Hist%C3%B3ria/Neste_dia"}, 
            link3 = {name:"Imagem em Destaque",url:"https://pt.wikipedia.org/wiki/Wikip%C3%A9dia:Imagem_em_destaque"},             
        ],
        preicon:"fab",
        icon:"fa-wikipedia-w",
        url:"https://pt.wikipedia.org/w/index.php",
        query:"?search=",
        ph:"Pesquisa Wikipedia",
        name:"wikipedia",
        method:"post",
        color:"#555" //Not used yet
    },
];
