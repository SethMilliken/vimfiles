#!/usr/bin/env bash
#
# Clone or update vim bundles
#
# -n only clones new additions, no updates.
#
# TODO: rewrite in ruby; check for present directories without a corresponding entry
#
# K to add entry for git clone URL on clipboard
# \<CR> to sort selection
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
            # ${DEBUG} git fetch --all -q && (${DEBUG} git up &> /dev/null)
            ${DEBUG} git fetch --all -q && (${DEBUG} git up)
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
#warning    syntastic            https://github.com/sjl/syntastic.git

#refresh    UltiSnips            https://github.com/vim-scripts/UltiSnips.git
#refresh    vimple               https://github.com/dahu/vimple.git
oldfork    gundo                git@github.com:SethMilliken/gundo.vim.git
oldfork    snipmate             https://github.com/spf13/snipmate.vim.git
oldfork    sparkup              https://github.com/kogakure/vim-sparkup.git
oldfork    tagbar               git@github.com:SethMilliken/tagbar.git
oldfork    tlib-seth            git@github.com:SethMilliken/tlib_vim.git
oldfork    tmux                 https://github.com/VimEz/Tmux.git
refresh    .pathogen-raimondi   https://github.com/Raimondi/vim-pathogen.git
refresh    abolish              https://github.com/tpope/vim-abolish.git
refresh    ack                  https://github.com/vim-scripts/ack.vim.git                   'brew install ack'
refresh    ansiesc              https://github.com/vim-scripts/AnsiEsc.vim.git
refresh    bufexplorer          https://github.com/vim-scripts/bufexplorer.zip.git
refresh    calendar             https://github.com/vim-scripts/calendar.vim--Matsumoto.git
refresh    cocoa                https://github.com/msanders/cocoa.vim.git
refresh    ctrlp                https://github.com/kien/ctrlp.vim.git
refresh    extradite            https://github.com/int3/vim-extradite.git
refresh    fugitive             https://github.com/tpope/vim-fugitive.git
refresh    fuzzyfinder          https://github.com/vim-scripts/FuzzyFinder.git
refresh    gist                 https://github.com/vim-scripts/Gist.vim.git
refresh    gitv                 https://github.com/gregsexton/gitv.git
refresh    gundo                https://github.com/sjl/gundo.vim.git
refresh    hexhighlight         https://github.com/yurifury/hexHighlight.git
refresh    javaScriptLint       https://github.com/smith/javaScriptLint.vim.git               'brew install jsl'
refresh    kellys               https://github.com/vim-scripts/kellys.git
refresh    l9                   https://github.com/slack/vim-l9.git
refresh    linediff             https://github.com/AndrewRadev/linediff.vim.git
refresh    matchit              https://github.com/vim-scripts/matchit.zip.git
refresh    matrix               https://github.com/vim-scripts/matrix.vim--Yang.git
refresh    nerdcommenter        https://github.com/scrooloose/nerdcommenter.git
refresh    nerdtree             https://github.com/scrooloose/nerdtree.git
refresh    paster               https://github.com/weierophinney/paster.vim.git
refresh    pathogen             https://github.com/tpope/vim-pathogen.git
refresh    pickacolor           https://github.com/Raimondi/PickAColor.git
refresh    rails                https://github.com/tpope/vim-rails.git
refresh    ruby-matchit         https://github.com/vim-scripts/ruby-matchit.git
refresh    screenshot           https://github.com/vim-scripts/ScreenShot.git
refresh    sessionman           https://github.com/vim-scripts/sessionman.vim.git
refresh    snipmate             https://github.com/garbas/vim-snipmate.git
refresh    space                https://github.com/spiiph/vim-space.git
refresh    sparkup              https://github.com/rstacruz/sparkup.git
refresh    splice               https://github.com/sjl/splice.vim.git
refresh    surround             https://github.com/vim-scripts/surround.vim.git
refresh    syntastic            https://github.com/scrooloose/syntastic.git
refresh    tabular              https://github.com/godlygeek/tabular.git
refresh    tagbar               https://github.com/majutsushi/tagbar.git
refresh    textobj-function     https://github.com/kana/vim-textobj-function.git
refresh    textobj-rubyblock    https://github.com/nelstrom/vim-textobj-rubyblock.git
refresh    textobj-user         https://github.com/kana/vim-textobj-user.git
refresh    tlib                 https://github.com/tomtom/tlib_vim.git
refresh    tmux                 https://github.com/keith/tmux.vim.git
refresh    viki                 https://github.com/tomtom/viki_vim.git
refresh    vim-addon-async      https://github.com/MarcWeber/vim-addon-async.git
refresh    vim-addon-manager    https://github.com/MarcWeber/vim-addon-manager.git
refresh    vim-addon-mw-utils   https://github.com/MarcWeber/vim-addon-mw-utils.git
refresh    vim-airline          https://github.com/vim-airline/vim-airline.git
refresh    vim-airline-themes   https://github.com/vim-airline/vim-airline-themes.git
refresh    vim-flake8           https://github.com/nvie/vim-flake8.git                         'pip install flake8'
refresh    vim-javascript       https://github.com/pangloss/vim-javascript.git
refresh    vim-mtg-spell        git@github.com:SethMilliken/vim-mtg-spell.git
refresh    vim-ruby             https://github.com/vim-ruby/vim-ruby.git
refresh    vim-scala            https://github.com/derekwyatt/vim-scala.git
refresh    vim-signify          https://github.com/mhinz/vim-signify.git
refresh    vim-traitor          git@github.com:SethMilliken/vim-traitor.git
refresh    tmux-focus-events    https://github.com/tmux-plugins/vim-tmux-focus-events.git    'set -g focus-events on in tmux'
refresh    vim-velocity         https://github.com/lepture/vim-velocity.git
refresh    vim-virtualenv       https://github.com/jmcantrell/vim-virtualenv.git
refresh    vim-virtualenv       https://github.com/plytophogy/vim-virtualenv.git
refresh    vimpager             https://github.com/rkitover/vimpager.git
refresh    vimwiki              https://github.com/vim-scripts/vimwiki.git
refresh    vundle               https://github.com/vim-scripts/vundle.git
refresh    xml                  https://github.com/vim-scripts/xml.vim.git
warning    autotag              https://github.com/vim-scripts/AutoTag.git
warning    command-t            https://github.com/wincent/Command-T.git                     'Rebuild if necessary:\n\tpushd command-t/ruby/command-t/; ruby extconf.rb; make && popd'
warning    conque               https://github.com/rson/vim-conque.git
warning    csapprox             https://github.com/godlygeek/csapprox.git
warning    dbext                https://github.com/vim-scripts/dbext.vim.git
warning    delimitMate          https://github.com/Raimondi/delimitMate.git
warning    javascript           https://github.com/serverhorror/javascript.vim.git
warning    jslint               https://github.com/vim-scripts/jslint.vim.git
warning    puppet-syntax-vim    https://github.com/puppetlabs/puppet-syntax-vim.git
warning    scala                https://github.com/vim-scripts/scala.vim.git
warning    script-ed            ssh://seth@at.araxia.net/~/git/script-ed.git
warning    statuslinehighlight  https://github.com/vim-scripts/StatusLineHighlight.git
warning    threesome            https://github.com/sjl/threesome.vim.git
warning    twitvim              https://github.com/vim-scripts/TwitVim.git
warning    vim-addon-signs      https://github.com/MarcWeber/vim-addon-signs.git
warning    vim-powerline        https://github.com/Lokaltog/vim-powerline.git
warning    vim-ragtag           na
warning    vim-vagrant          https://github.com/markcornick/vim-vagrant.git
