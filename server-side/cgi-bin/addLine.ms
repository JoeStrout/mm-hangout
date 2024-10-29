#!/usr/bin/env miniscript

import "stringUtil"
import "util"
import "dateTime"

// How many lines we allow per file (total number of lines is twice this):
LINE_LIMIT = 5

print "Content-type: text/plain"
print

postData = readPostData
if not postData.hasIndex("line") or not postData.hasIndex("file") then
	print "ERROR: expected line and file parameters in post data"
	exit
end if

pathBase = FILE_DIR + postData.file
path = pathBase + ".curr.txt"
lines = file.readLines(path)
if not lines then lines = ["0:"]
lineNum = val(lines[-1].split(TAB)[0]) + 1

if lines.len >= LINE_LIMIT then
	// This file has gotten as big as it can be.  It now becomes the
	// prev file, and we start a new cur file.
	file.delete pathBase + ".prev.txt"
	file.move path, pathBase + ".prev.txt"
end if

f = file.open(path, "a")
f.writeLine lineNum + TAB + dateTime.now + TAB + postData.line

print "OK!"
print "lineNum: " + lineNum
