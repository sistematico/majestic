# PATH
export COMPOSER_HOME=${HOME}/.composer
[ -d ${HOME}/bin ] && export PATH=$PATH:$HOME/bin
[ -d ${HOME}/apps ] && export PATH=${PATH}:${HOME}/apps
[ -d ${HOME}/.npm/bin ] && export PATH=${PATH}:${HOME}/.npm/bin
[ -d ${HOME}/.deno/bin ] && export PATH=${PATH}:${HOME}/.deno/bin
[ -d ${COMPOSER_HOME}/vendor/bin ] && export PATH=${PATH}:${COMPOSER_HOME}/vendor/bin

RANGER_LOAD_DEFAULT_RC=FALSE
