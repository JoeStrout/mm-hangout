// Asynchronous (i.e. non-blocking) functions and utilities,
// such as a way to get input without blocking program flow.


input = {}
input.inProgress = false

input.begin = function(prompt="")
	print prompt, ""
	self.row = text.row
	self.column = text.column
	self.cursorRow = text.row
	self.cursorCol = text.column
	self.buffer = ""
	self.cursorPos = 0
	self.inProgress = true
	self._showCursor
end function

input._showCursor = function
	text.setCellBackColor self.cursorCol, self.cursorRow, text.color
	text.setCellColor self.cursorCol, self.cursorRow, text.backColor
	self.cursorOn = true
	self.cursorStartTime = time
end function

input._hideCursor = function	
	text.setCellBackColor self.cursorCol, self.cursorRow, text.backColor
	text.setCellColor self.cursorCol, self.cursorRow, text.color
	self.cursorOn = false
	self.cursorStartTime = time
end function

input.done = function
	if not self.inProgress then return false
	if self.cursorOn and time > self.cursorStartTime + 0.7 then
		self._hideCursor
	else if not self.cursorOn and time > self.cursorStartTime + 0.3 then
		self._showCursor
	end if
	if not key.available then return false
	self._hideCursor
	k = key.get
	kc = k.code
	if kc == 10 or kc == 13 or kc == 3 then
		text.row = self.cursorRow
		text.column = self.cursorCol
		print
		return true
	else if kc == 17 then  // left arrow
		if self.cursorPos > 0 then self.cursorPos -= 1
	else if kc == 18 then  // right arrow
		if self.cursorPos < self.buffer.len then self.cursorPos += 1
	else if kc == 8 then   // backspace
		if self.cursorPos > 0 then
			self.buffer = self.buffer[:self.cursorPos-1] + self.buffer[self.cursorPos:]
			self.cursorPos -= 1
		end if
	else if kc == 127 then // forward delete
		if self.cursorPos < self.buffer.len then
			self.buffer = self.buffer[:self.cursorPos] + self.buffer[self.cursorPos+1:]
		end if
	else if kc == 1 or kc == 19 then  // Control-A or up-arrow
		self.cursorPos = 0
	else if kc == 5 or kc == 20 then  // Control-E or down-arrow
		self.cursorPos = self.buffer.len
	else
		self.buffer = self.buffer[:self.cursorPos] + k + self.buffer[self.cursorPos:]
		self.cursorPos += 1
	end if
	text.row = self.row; text.column = self.column
	print self.buffer[:self.cursorPos], ""
	self.cursorRow = text.row
	self.cursorCol = text.column
	print self.buffer[self.cursorPos:], " "
	self._showCursor
	return false
end function

input.result = function
	self.inProgress = false
	return self.buffer
end function

if locals == globals then
	clear
	print "Demo of non-blocking input... ", "/"
	r = text.row; c = text.column - 1
	frames = "----////||||\\\\"
	frame = 0
	print
	input.begin "Enter some text: "
	while true
		frame = (frame + 1) % frames.len
		text.row = r; text.column = c; print frames[frame]
		if input.done then
			print "You entered: " + input.result
			print "(Press control-C to exit.)"
		end if
		yield
	end while

end if