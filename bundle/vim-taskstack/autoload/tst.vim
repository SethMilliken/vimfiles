vim9script

import autoload "logging.vim"

var log = logging.Logger.new()

# Constants {{{
const UNSET = "UNSET"
const FOLD_MARKER_OPEN  = split(&foldmarker, ",")[0]
const FOLD_MARKER_CLOSE = split(&foldmarker, ",")[1]
const PROJECT_RAW_MATCH_PATTERN = '^@\zs\(\<[-_.+[:alnum:]]*\>\.*\s*\)\{,3}\ze\s\+'
const CATEGORY_RAW_MATCH_PATTERN = '^\zs\([A-Z]\{3,}\s*\)\{1,3}\ze\s\+'

# }}}
# Base {{{
#
# Provides methods shared by multiple classes
#
abstract class BaseClass
    # FIXME: vim 9.0 inexplicably locks up when extending an abstract class with a
    # class that has instance variables unless the abstract class has at least
    # one instance variable
    #this.fixme: number

    def SetMark()
        mark '
    enddef
endclass

# }}}
# Project {{{
#
# A Project is a container for Tasks
#
# It can be a fold with a header beginning with "@"
# Or it can be a file in a designated directory whose name
# TODO: create tst project for writing this plugin
# TODO: figure out how to properly document use of these classes and their
# functions
# TODO: create a function to find the Project with a name, looking first in
# the current file, then in the designated directory, and offering to create
# one or the other if neither exists
# Example:
#
# @projectname {{{
# - item one
# - item two
#
# }}}
#
# Created 2024-03-27
# Previous prototype effort was not well organized; this is an attempt to
# reimplement much of that using vim9script classes
export class Project extends BaseClass
    var _name = UNSET

    def new(this._name)
    enddef

    def newFromFold()
        this.SetName(Project.DetectNameFromCurrentFold())
    enddef

    def newFromWord()
        this.SetName(Project.DetectNameFromCurrentWord())
    enddef

    def SetName(name: string)
        this._name = len(name) > 0 ? name : UNSET
    enddef

    def GetName(): string
        return this._name
    enddef

    def GetContents(): list<string>
        return [ "@" .. this.GetName() .. ' ' .. FOLD_MARKER_OPEN, FOLD_MARKER_CLOSE ]
    enddef

    def AppendUnder(candidate: number)
        final target = candidate > line('$') ? line('$') : candidate
        this.SetMark()
        append(target, this.GetContents())
    enddef

    def InsertUnderCurrentLine()
        this.AppendUnder(line("."))
    enddef

    def InsertUnderCurrentProject()
        this.AppendUnder(Project.FindEndFold())
    enddef

    # static functions
    static def DetectNameFromCurrentFold(): string
        final containing_line = Project.LineOfContainingFold(line('.'))
        if (containing_line > -1)
            return Project.DetectHeaderName(containing_line)
        endif
        return UNSET
    enddef

    static def LineOfContainingFold(line: number): number
        var i = line
        while i > -1 && !Project.IsProjectHeaderLine(i)
            i = i - 1
        endwhile
        return i
    enddef

    static def IsProjectHeaderLine(line: number): bool
        final project = Project.DetectHeaderName(line)
        return (len(project) > 0)
    enddef

    static def DetectNameFromCurrentWord(): string
        return trim(expand('<cWORD>'), "@")
    enddef

    static def DetectHeaderName(line: number): string
        final project_name = matchstr(getline(line), '\(' .. PROJECT_RAW_MATCH_PATTERN .. '\|' .. CATEGORY_RAW_MATCH_PATTERN .. '\)' .. FOLD_MARKER_OPEN)
        return project_name
    enddef

    static def FindEndFold(): number
        var expression = "\\s*" .. FOLD_MARKER_CLOSE
        return search(expression, 'csw')
    enddef

endclass

# }}}
# Fold Prototype {{{
#
# A Fold container representing a vim fold
# Used to navigate folds and manipulate their state
#
export class Fold extends BaseClass
    var _start = 0
    var _end = 0

    def SetStart(startLine: number)
        this._start = startLine
    enddef

    def SetEnd(endLine: number)
        this._end = endLine
    enddef

    def GetContents(): list<string>
        return ["unimplemented", "method"]
    enddef

    # static functions
    static def DetectHeader(): string
        return "unimplemented"
    enddef

    static def FindStartFold()
        # TODO: add methods to determine markers
        final expression = "\\s*" . FOLD_MARKER_OPEN
        return search(expression, 'bcsw')
    enddef

    static def FindEndFold()
        # TODO: add methods to determine markers
        final expression = "\\s*" . FOLD_MARKER_CLOSE
        return search(expression, 'csw')
    enddef

    # instance constructors
    def new(line: number)
        # TODO: implement static methods to determine these
        var start = 0
        var end = 0
        this.SetStart(start)
        this.SetEnd(end)
    enddef

    def newHere()
        return this.new(get("."))
    enddef

endclass

# Legacy vimscript Integration
# Legacy vimscript cannot instantiate vim9script classes, so
# these must use the vim9-autoload functionality, invoked as
# e.g. `call tst#ProjectFromWord()`
export def ProjectFromWord(): Project
    return Project.newFromWord()
enddef

export def ProjectNew(name: string): Project
    return Project.new(name)
enddef

#var proj = Project.new("some")
#log.Info($'{proj.GetName()}')
#log.Info($'{Project.IsProjectHeaderLine(43)}')

export def FileEntry(file: string, entry: string): string # {{{
    # reimplement in vim9script
    return "Unimplemented"
enddef

# }}}
# }}}
