#!/bin/bash
#
# Clone or update vim bundles
#
# -n only clones new additions, no updates.
#
DEBUG=
#DEBUG=echo
ARG=$1

function refresh_bundle {
    NAME=$1
    URL=$2
    COMMENT=$3
    printf "===============================================[     %18s   ]=====" ${NAME}
    if [ -d ${NAME} ]; then
        if [[ $ARG == "-n" ]]; then
            COMMENT='  update skipped'
        else
            echo ""
            pushd ${NAME} &> /dev/null
            ${DEBUG} git upbase
            popd &> /dev/null
        fi
    else
        echo ""
        ${DEBUG} git clone ${URL} ${NAME}
    fi
    if ! [[ "${COMMENT}" == ""  ]]; then
        echo "${COMMENT}"
    fi
}


# refresh_bundle gundo git@github.com:SethMilliken/gundo.vim.git
# refresh_bundle viki git://github.com/tomtom/viki_vim.git
#refresh_bundle dbext git://github.com/vim-scripts/dbext.vim.git # too buggy
#refresh_bundle tagbar git://github.com/majutsushi/tagbar.git
#refresh_bundle vim-addon-async git://github.com/MarcWeber/vim-addon-async.git
#refresh_bundle vim-addon-signs git://github.com/MarcWeber/vim-addon-signs.git
#refresh_bundle vimple git://github.com/dahu/vimple.git
refresh_bundle abolish git://github.com/tpope/vim-abolish.git
refresh_bundle ansiesc git://github.com/vim-scripts/AnsiEsc.vim.git
refresh_bundle autotag git://github.com/vim-scripts/AutoTag.git
refresh_bundle bufexplorer git://github.com/vim-scripts/bufexplorer.zip.git
refresh_bundle calendar git://github.com/vim-scripts/calendar.vim--Matsumoto.git
refresh_bundle cocoa git://github.com/msanders/cocoa.vim.git
refresh_bundle command-t git://github.com/wincent/Command-T.git 'Remember to rebuild if necessary:\n\tpushd command-t/ruby/command-t/; ruby extconf.rb; make && popd'
refresh_bundle conque git://github.com/rson/vim-conque.git
refresh_bundle fugitive git://github.com/tpope/vim-fugitive.git
refresh_bundle fuzzyfinder git://github.com/vim-scripts/FuzzyFinder.git
refresh_bundle gundo git://github.com/sjl/gundo.vim.git
refresh_bundle hexhighlight git://github.com/yurifury/hexHighlight.git
refresh_bundle jslint git://github.com/vim-scripts/jslint.vim.git
refresh_bundle kellys git://github.com/vim-scripts/kellys.git
refresh_bundle l9 git://github.com/slack/vim-l9.git
refresh_bundle matrix git://github.com/vim-scripts/matrix.vim--Yang.git
refresh_bundle nerdcommenter git://github.com/scrooloose/nerdcommenter.git
refresh_bundle nerdtree git://github.com/scrooloose/nerdtree.git
refresh_bundle paster git://github.com/weierophinney/paster.vim.git
refresh_bundle pickacolor git://github.com/Raimondi/PickAColor.git
refresh_bundle project git://github.com/shemerey/vim-project.git
refresh_bundle rails git://github.com/tpope/vim-rails.git
refresh_bundle screenshot git://github.com/vim-scripts/ScreenShot.git
refresh_bundle sessionman git://github.com/vim-scripts/sessionman.vim.git
refresh_bundle snipmate git://github.com/spf13/snipmate.vim.git
refresh_bundle space git://github.com/spiiph/vim-space.git
refresh_bundle statuslinehighlight git://github.com/vim-scripts/StatusLineHighlight.git
refresh_bundle surround git://github.com/vim-scripts/surround.vim.git
refresh_bundle syntastic git://github.com/sjl/syntastic.git
refresh_bundle tagbar git@github.com:SethMilliken/tagbar.git
refresh_bundle textobj-function git://github.com/kana/vim-textobj-function.git
refresh_bundle textobj-rubyblock git://github.com/nelstrom/vim-textobj-rubyblock.git
refresh_bundle textobj-user git://github.com/kana/vim-textobj-user.git
refresh_bundle twitvim git://github.com/vim-scripts/TwitVim.git
refresh_bundle vcscommand git://github.com/vim-scripts/vcscommand.vim.git
refresh_bundle vim-ruby git://github.com/vim-ruby/vim-ruby.git
refresh_bundle vimwiki git://github.com/vim-scripts/vimwiki.git
