// This script provides access to all the APIs (CGI scripts) on
// the server, and wraps them in a nice interface that hopefully
// hides most of the hairy details.

SERVER_URL = "localhost:8000"
CGI_DIR = "/cgi-bin/"

import "importUtil"
ensureImport "stringUtil"
ensureImport "dateTime"

_apiURL = function(api)
	return SERVER_URL + CGI_DIR + api + ".ms"
end function

EOL = char(10)		// standard line ending in HTTP

splitLines = function(s)
	return s.split(EOL)
end function

// test: check whether the server is running and responding to
// requests at all.  Should return "OK" and some server details.
// Returns HTTP error string (e.g. "HTTP/1.1 404 Not Found") in
// case of failure.
test = function
	result = http.get(_apiURL("test"))
	return result
end function


// addLine: adds a line of text to a circular file.
addLine = function(filename, lineOfText)
	lineOfText = lineOfText.replace(char(13), "\n")
	lineOfText = lineOfText.replace(char(10), "\n")
	data = {}
	data.file = filename
	data.line = lineOfText
	pprint data
	result = http.post(_apiURL("addLine"), data)
	return result
end function

// getLines: gets all lines at or after a given line number.
getLines = function(filename, firstLineNum)
	url = _apiURL("getLines") + "?file=" + filename + "&lineNum=" + firstLineNum
	result = http.get(url)
	if not result then return []
	return result.split(EOL)
end function

if locals == globals then
	print "Calling: test"
	result = test
	if result.startsWith("OK!") then
		print "Looks like the server is running!"
	end if
	print result
	
	print "Calling: addLine (to file 'test')"
	result = addLine("test", "Test line at " + dateTime.now)
	print result
	
	print "Calling: getLines (file 'test' from line 0)"
	result = getLines("test", 0)
	print result
end if
