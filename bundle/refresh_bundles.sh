#!/bin/sh
# Clone or update vim bundles
DEBUG=
#DEBUG=echo

function refresh_bundle {
	NAME=$1
	URL=$2
	COMMENT=$3
	printf "===============================================     %15s   =====\n" ${NAME}
	if [ -d ${NAME} ]
	then
		pushd ${NAME} &> /dev/null
		${DEBUG} git upbase
		popd &> /dev/null
	else
		${DEBUG} git clone ${URL} ${NAME}
	fi
	if [ "$COMMENT" ]
	then
		echo "${COMMENT}"
	fi
}

refresh_bundle rails git://github.com/tpope/vim-rails.git
refresh_bundle gundo git://github.com/sjl/gundo.vim.git
refresh_bundle fugitive git://github.com/tpope/vim-fugitive.git
refresh_bundle conque git://github.com/rson/vim-conque.git
refresh_bundle pickacolor git://github.com/Raimondi/PickAColor.git
refresh_bundle command-t git://github.com/wincent/Command-T.git 'Remember to rebuild if necessary:\n\tpushd command-t/ruby/command-t/; ruby extconf.rb; make && popd'
