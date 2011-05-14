#!/bin/bash
#
# Clone or update vim bundles
#
# -n only clones new additions, no updates.
#
DEBUG=
#DEBUG=echo
ARG=$1

function refresh {
    NAME=$1
    URL=$2
    COMMENT=$3
    printf "===============================================[     %20s   ]=====" ${NAME}
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

#refresh    dbext                git://github.com/vim-scripts/dbext.vim.git
#refresh    gundo                git@github.com:SethMilliken/gundo.vim.git
#refresh    tagbar               git@github.com:SethMilliken/tagbar.git
#refresh    tlib-seth            git@github.com:SethMilliken/tlib_vim.git
#refresh    viki                 git://github.com/tomtom/viki_vim.git
#refresh    vim-addon-signs      git://github.com/MarcWeber/vim-addon-signs.git
#refresh    vimple               git://github.com/dahu/vimple.git
refresh    .pathogen-raimondi   git://github.com/Raimondi/vim-pathogen.git
refresh    abolish              git://github.com/tpope/vim-abolish.git
refresh    ack                  git://github.com/vim-scripts/ack.vim.git                   'brew install ack'
refresh    ansiesc              git://github.com/vim-scripts/AnsiEsc.vim.git
refresh    autotag              git://github.com/vim-scripts/AutoTag.git
refresh    bufexplorer          git://github.com/vim-scripts/bufexplorer.zip.git
refresh    calendar             git://github.com/vim-scripts/calendar.vim--Matsumoto.git
refresh    cocoa                git://github.com/msanders/cocoa.vim.git
refresh    command-t            git://github.com/wincent/Command-T.git                     'Rebuild if necessary:\n\tpushd command-t/ruby/command-t/; ruby extconf.rb; make && popd'
refresh    conque               git://github.com/rson/vim-conque.git
refresh    csapprox             git://github.com/godlygeek/csapprox.git
refresh    extradite            git://github.com/int3/vim-extradite.git
refresh    fugitive             git://github.com/tpope/vim-fugitive.git
refresh    fuzzyfinder          git://github.com/vim-scripts/FuzzyFinder.git
refresh    gundo                git://github.com/sjl/gundo.vim.git
refresh    hexhighlight         git://github.com/yurifury/hexHighlight.git
refresh    javaScriptLint       git://github.com/smith/javaScriptLint.vim.git               'brew install jsl'
refresh    javascript           git://github.com/serverhorror/javascript.vim.git
refresh    jslint               git://github.com/vim-scripts/jslint.vim.git
refresh    kellys               git://github.com/vim-scripts/kellys.git
refresh    l9                   git://github.com/slack/vim-l9.git
refresh    matchit              git://github.com/vim-scripts/matchit.zip.git
refresh    matrix               git://github.com/vim-scripts/matrix.vim--Yang.git
refresh    nerdcommenter        git://github.com/scrooloose/nerdcommenter.git
refresh    nerdtree             git://github.com/scrooloose/nerdtree.git
refresh    paster               git://github.com/weierophinney/paster.vim.git
refresh    pathogen         git://github.com/tpope/vim-pathogen.git
refresh    pickacolor           git://github.com/Raimondi/PickAColor.git
refresh    project              git://github.com/shemerey/vim-project.git
refresh    rails                git://github.com/tpope/vim-rails.git
refresh    ruby-matchit         git://github.com/vim-scripts/ruby-matchit.git
refresh    screenshot           git://github.com/vim-scripts/ScreenShot.git
refresh    script-ed            ssh://seth@at.araxia.net/~/git/script-ed.git
refresh    sessionman           git://github.com/vim-scripts/sessionman.git
refresh    snipmate             git://github.com/spf13/snipmate.vim.git
refresh    space                git://github.com/spiiph/vim-space.git
refresh    sparkup              git://github.com/kogakure/vim-sparkup.git
refresh    statuslinehighlight  git://github.com/vim-scripts/StatusLineHighlight.git
refresh    surround             git://github.com/vim-scripts/surround.vim.git
refresh    syntastic            git://github.com/sjl/syntastic.git
refresh    tagbar               git://github.com/majutsushi/tagbar.git
refresh    textobj-function     git://github.com/kana/vim-textobj-function.git
refresh    textobj-rubyblock    git://github.com/nelstrom/vim-textobj-rubyblock.git
refresh    textobj-user         git://github.com/kana/vim-textobj-user.git
refresh    tlib                 git://github.com/tomtom/tlib_vim.git
refresh    twitvim              git://github.com/vim-scripts/TwitVim.git
refresh    vcscommand           git://github.com/vim-scripts/vcscommand.vim.git
refresh    viki                 git://github.com/vim-scripts/VikiDeplate.git
refresh    vim-addon-async      git://github.com/MarcWeber/vim-addon-async.git
refresh    vim-javascript       git://github.com/pangloss/vim-javascript.git
refresh    vim-ragtag           git://github.com/tpope/vim-ragtag.git
refresh    vim-ruby             git://github.com/vim-ruby/vim-ruby.git
refresh    vimwiki              git://github.com/vim-scripts/vimwiki.git
refresh    vundle               git://github.com/vim-scripts/vundle.git
refresh    xml                  git://github.com/vim-scripts/xml.vim.git
