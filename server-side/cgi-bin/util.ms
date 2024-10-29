// Various utility functions and constants useful for all the API scripts.

globals.FILE_DIR = "../data/"
globals.TAB = char(9)
globals.EOL = char(10)

// HexVal: convert a hexadecimal string to a number.
globals.hexVal = function(hexstr)
	result = 0
	digits = "0123456789ABCDEF"
	for c in hexstr
		cval = digits.indexOf(c.upper)
		if cval < 0 then break
		result = result * 16 + cval
	end for
	return result
end function

string.urlDecode = function
    result = []
    i = 0
    while i < self.len
        c = self[i]
        if c == "%" then
            hexStr = self[i+1:i+3]
            i = i + 3
            result.push char(hexVal(hexStr))
        else
            result.push c
            i = i + 1
        end if
    end while
    return result.join("")
end function

// Parse a query string into a map.
globals.parseQueryString = function(qs)
	result = {}
	kvPairs = qs.split("&")
	for pair in kvPairs
		kv = pair.split("=")
		if kv.len == 1 then
			result[kv[0].urlDecode] = true
		else
			value = kv[1].urlDecode
			if value.isNumeric then value = val(value)
			result[kv[0].urlDecode] = value
		end if
	end for
	return result
end function

globals.getRawPostData = function
	contentLen = val(env.CONTENT_LENGTH)
	if contentLen <= 0 then return ""
	f = file.open("/dev/stdin", "r")
	postData = f.read(contentLen)
	f.close
	return postData
end function
	
globals.readPostData = function
	return parseQueryString(getRawPostData)
end function

globals.getQueryParams = function
	return parseQueryString(env.QUERY_STRING)
end function


