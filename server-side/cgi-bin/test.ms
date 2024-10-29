#!/usr/bin/env miniscript

// Test API.  Simply returns "OK" plus some server details.

print "Content-type: text/plain"
print
print "OK!"
for kv in version
	print kv.key + ": " + kv.value
end for
