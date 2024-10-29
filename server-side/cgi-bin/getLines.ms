#!/usr/bin/env miniscript

// API to get updated lines, if any, from a (circular) file.
// Query parameters:
//
//	file: name of file to read from
//	lineNum: first line number to get (or 0 for all)
//
// Note that the requested line number may not be available,
// but you'll get everything available after that.  Result
// is a series of lines with the format:
//	lineNum<TAB>timestamp<TAB>data
//
// On your next call, you should specify the highest line
// number seen, plus one.

import "stringUtil"
import "util"

print "Content-type: text/plain"
print

params = getQueryParams
if not params.hasIndex("file") or not params.hasIndex("lineNum") then
	print "Error: expect file and lineNum in query params"
	exit
end if

pathBase = FILE_DIR + params.file
path = pathBase + ".curr.txt"
curLines = file.readLines(path)
if not curLines then exit

firstCurLine = curLines[0].split(TAB)[0].val
lastCurLine = curLines[-1].split(TAB)[0].val

// There are several cases, depending on where params.lineNum
// falls relative to the lines in curLines.

// Case 1: beyond the last line, nothing to return.
if params.lineNum > lastCurLine then exit

// Case 2: among the lines in the current file.
if params.lineNum >= firstCurLine then
	lines = curLines[params.lineNum - firstCurLine:]
else
	// Case 3: before the current file; provide some subset
	// of the previous file too.
	lines = curLines
	prevLines = file.readLines(pathBase + ".prev.txt")
	if prevLines then
		firstPrevLine = prevLines[0].split(TAB)[0].val
		fromIdx = params.lineNum - firstPrevLine
		if fromIdx < 0 then fromIdx = 0
		lines = prevLines[fromIdx:] + lines
	end if
end if

for line in lines
	print line
end for
