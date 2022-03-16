# PATH

# Node
export NODE_VERSION=v16.14.0

export COMPOSER_HOME=${HOME}/.composer
[ -d ${HOME}/bin ] && export PATH=$PATH:$HOME/bin
[ -d ${HOME}/apps ] && export PATH=${PATH}:${HOME}/apps
[ -d ${HOME}/.npm/bin ] && export PATH=${PATH}:${HOME}/.npm/bin
[ -d ${HOME}/.deno/bin ] && export PATH=${PATH}:${HOME}/.deno/bin
[ -d ${COMPOSER_HOME}/vendor/bin ] && export PATH=${PATH}:${COMPOSER_HOME}/vendor/bin
[ -d /usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64/bin ] && export PATH=/usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64/bin:$PATH

RANGER_LOAD_DEFAULT_RC=FALSE
