// This script provides access to all the APIs (CGI scripts) on
// the server, and wraps them in a nice interface that hopefully
// hides most of the hairy details.

SERVER_URL = "localhost:8000"
CGI_DIR = "/cgi-bin/"

import "importUtil"
ensureImport "stringUtil"

// test: check whether the server is running and responding to
// requests at all.  Should return "OK" and some server details.
// Returns HTTP error string (e.g. "HTTP/1.1 404 Not Found") in
// case of failure.
test = function
	result = http.get(SERVER_URL + CGI_DIR + "test.ms")
	return result
end function


if locals == globals then
	print "Calling: test"
	result = test
	if result.startsWith("OK!") then
		print "Looks like the server is running!"
	end if
	print result
	
	
	
end if
