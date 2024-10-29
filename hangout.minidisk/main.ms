// Main program for Mini Micro Hangout.

import "netapi"
import "async"

TAB = char(9)

clear
username = input("Enter user name: ")

clear

display(5).mode = displayMode.text
chatDisp = display(5)
chatDisp.clear
chatDisp.color = color.lime

lastLineNumSeen = 0
nextCheckTime = 0
checkInterval = 0.1

// for debugging:
checkSound = Sound.init(0.1, [220,880], [1,0], Sound.triangleWave)

handleChatLine = function(line)
	fields = line.split(TAB)
	if fields.len < 3 then return
	outer.lastLineNumSeen = val(fields[0])
	chatDisp.print fields[2]
	row = chatDisp.row
	while row < 2
		chatDisp.row = 0; chatDisp.print
		row += 1
	end while
	chatDisp.row = row
end function

updateChat = function
	if time < nextCheckTime then return
	//checkSound.play
	lines = netapi.getLines("lobby", lastLineNumSeen + 1)
	if not lines then
		outer.checkInterval *= 2
		if checkInterval > 3 then outer.checkInterval = 3
		outer.nextCheckTime = time + checkInterval
		return
	end if

	for line in lines
		handleChatLine line
	end for
	outer.checkInterval = 0.1
	outer.nextCheckTime = time + checkInterval
end function

while true
	yield
	updateChat
	if not async.input.inProgress then
		text.clear
		text.row = 1
		text.column = 0
		async.input.begin(">")
	end if
	if async.input.done then
		msg = async.input.result
		if msg then
			netapi.addLine "lobby", username + ": " + msg
			nextCheckTime = 0	// check right away!
		end if
	end if	
end while
