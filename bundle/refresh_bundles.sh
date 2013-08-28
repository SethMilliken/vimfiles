#!/usr/bin/env bash
#
# Clone or update vim bundles
#
# -n only clones new additions, no updates.
#
# TODO: rewrite in ruby; check for present directories without a corresponding entry
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
            ${DEBUG} git f && ${DEBUG} git up
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

function warning {
    NAME=$1
    if [ -d ${NAME} ]; then
        if [[ $ARG == "-n" ]]; then
            echo "Removing ${NAME}..."
            rm -r "${NAME}"
        else
            echo "${NAME} should be removed (use -n to do so automatically)."
        fi
    fi
}

function oldfork {
    ! [ true ] && echo "noop"
}

#refresh    vim-powerline        git@github.com:SethMilliken/vim-powerline.git
#warning    syntastic            git://github.com/sjl/syntastic.git
oldfork    gundo                git@github.com:SethMilliken/gundo.vim.git
oldfork    snipmate             git://github.com/spf13/snipmate.vim.git
oldfork    tagbar               git@github.com:SethMilliken/tagbar.git
oldfork    tlib-seth            git@github.com:SethMilliken/tlib_vim.git
refresh    .pathogen-raimondi   git://github.com/Raimondi/vim-pathogen.git
refresh    UltiSnips            git://github.com/vim-scripts/UltiSnips.git
refresh    abolish              git://github.com/tpope/vim-abolish.git
refresh    ack                  git://github.com/vim-scripts/ack.vim.git                   'brew install ack'
refresh    ansiesc              git://github.com/vim-scripts/AnsiEsc.vim.git
refresh    autotag              git://github.com/vim-scripts/AutoTag.git
refresh    bufexplorer          git://github.com/vim-scripts/bufexplorer.zip.git
refresh    calendar             git://github.com/vim-scripts/calendar.vim--Matsumoto.git
refresh    cocoa                git://github.com/msanders/cocoa.vim.git
refresh    ctrlp                git://github.com/kien/ctrlp.vim.git
refresh    extradite            git://github.com/int3/vim-extradite.git
refresh    fugitive             git://github.com/tpope/vim-fugitive.git
refresh    fuzzyfinder          git://github.com/vim-scripts/FuzzyFinder.git
refresh    gist                 git://github.com/vim-scripts/Gist.vim.git
refresh    gitv                 git://github.com/gregsexton/gitv.git
refresh    gundo                git://github.com/sjl/gundo.vim.git
refresh    hexhighlight         git://github.com/yurifury/hexHighlight.git
refresh    javaScriptLint       git://github.com/smith/javaScriptLint.vim.git               'brew install jsl'
refresh    javascript           git://github.com/serverhorror/javascript.vim.git
refresh    jslint               git://github.com/vim-scripts/jslint.vim.git
refresh    kellys               git://github.com/vim-scripts/kellys.git
refresh    l9                   git://github.com/slack/vim-l9.git
refresh    linediff             git://github.com/AndrewRadev/linediff.vim.git
refresh    matchit              git://github.com/vim-scripts/matchit.zip.git
refresh    matrix               git://github.com/vim-scripts/matrix.vim--Yang.git
refresh    nerdcommenter        git://github.com/scrooloose/nerdcommenter.git
refresh    nerdtree             git://github.com/scrooloose/nerdtree.git
refresh    paster               git://github.com/weierophinney/paster.vim.git
refresh    pathogen             git://github.com/tpope/vim-pathogen.git
refresh    pickacolor           git://github.com/Raimondi/PickAColor.git
refresh    puppet-syntax-vim    git://github.com/puppetlabs/puppet-syntax-vim.git
refresh    rails                git://github.com/tpope/vim-rails.git
refresh    ruby-matchit         git://github.com/vim-scripts/ruby-matchit.git
refresh    screenshot           git://github.com/vim-scripts/ScreenShot.git
refresh    sessionman           git://github.com/vim-scripts/sessionman.git
refresh    snipmate             git://github.com/garbas/vim-snipmate.git
refresh    space                git://github.com/spiiph/vim-space.git
refresh    sparkup              git://github.com/kogakure/vim-sparkup.git
refresh    splice               git://github.com/sjl/splice.vim.git
refresh    statuslinehighlight  git://github.com/vim-scripts/StatusLineHighlight.git
refresh    surround             git://github.com/vim-scripts/surround.vim.git
refresh    syntastic            git://github.com/scrooloose/syntastic.git
refresh    tabular              git://github.com/godlygeek/tabular.git
refresh    tagbar               git://github.com/majutsushi/tagbar.git
refresh    textobj-function     git://github.com/kana/vim-textobj-function.git
refresh    textobj-rubyblock    git://github.com/nelstrom/vim-textobj-rubyblock.git
refresh    textobj-user         git://github.com/kana/vim-textobj-user.git
refresh    tlib                 git://github.com/tomtom/tlib_vim.git
refresh    tmux                 git://github.com/VimEz/Tmux.git
refresh    twitvim              git://github.com/vim-scripts/TwitVim.git
refresh    viki                 git://github.com/tomtom/viki_vim.git
refresh    vim-addon-async      git://github.com/MarcWeber/vim-addon-async.git
refresh    vim-addon-manager    git://github.com/MarcWeber/vim-addon-manager.git
refresh    vim-addon-mw-utils   git://github.com/MarcWeber/vim-addon-mw-utils.git
refresh    vim-airline          git@github.com:bling/vim-airline.git
refresh    vim-javascript       git://github.com/pangloss/vim-javascript.git
refresh    vim-ruby             git://github.com/vim-ruby/vim-ruby.git
refresh    vim-scala            git://github.com/derekwyatt/vim-scala.git
refresh    vim-signify          git@github.com:mhinz/vim-signify.git
refresh    vim-traitor          git@github.com:SethMilliken/vim-traitor.git
refresh    vimple               git://github.com/dahu/vimple.git
refresh    vimwiki              git://github.com/vim-scripts/vimwiki.git
refresh    vundle               git://github.com/vim-scripts/vundle.git
refresh    xml                  git://github.com/vim-scripts/xml.vim.git
warning    command-t            git://github.com/wincent/Command-T.git                     'Rebuild if necessary:\n\tpushd command-t/ruby/command-t/; ruby extconf.rb; make && popd'
warning    conque               git://github.com/rson/vim-conque.git
warning    csapprox             git://github.com/godlygeek/csapprox.git
warning    dbext                git://github.com/vim-scripts/dbext.vim.git
warning    delimitMate          git://github.com/Raimondi/delimitMate.git
warning    scala                git://github.com/vim-scripts/scala.vim.git
warning    script-ed            ssh://seth@at.araxia.net/~/git/script-ed.git
warning    threesome            git://github.com/sjl/threesome.vim.git
warning    vim-addon-signs      git://github.com/MarcWeber/vim-addon-signs.git
warning    vim-powerline        git://github.com/Lokaltog/vim-powerline.git
warning    vim-ragtag           na
