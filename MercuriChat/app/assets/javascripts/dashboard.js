// Referenced from "The Definitive Guide to HTML5 WebSocket"
// Start a new WebSocket

//= require jquery
//= require jquery_ujs

url = "ws://localhost:3000";  
//url = "ws://localhost:8080/echo";
w = new WebSocket(url);  


// The following WebSocket events are referenced from the following sources--
// Referenced from: https://www.youtube.com/watch?v=WDowDtfWiGQ 
// Referenced from: http://www.tutorialspoint.com/html5/html5_websocket.htm

// WebSocket Event: open
// Description: occurs when WebSocket connection is established
w.onopen = function() {
	console.log("w.onopen: WebSocket has been opened!");

	// Sends message to confirm it works:
	// var str = "Thank you for opening this WebSocket request!";
	// w.send(str);
	// console.log("w.onopen: <" + str + "> was sent!");
}

// WebSocket Event: message
// Description: occurs when the client receives data from server.
w.onmessage = function(e) {
	console.log("w.onmessage:" + e.data.toString());
	// Creating new variables for alert msgs:
	var alrtstr1 = "<div class=\"alert alert-msg\" role=\"alert\">";
	var alrtstr2 = "</div>";

	displayMessage(alrtstr1 + e.data.toString() + alrtstr2);
}

// WebSocket Event: error
// Description: occurs when there is an error in communication.
w.onerror = function(e) {
	console.log("w.onerror: WebSocket has encountered an error.");
}

// WebSocket Event: close
// Description: occurs when the WebSocket connection is closed.
w.onclose = function(e) {
	console.log("onclose: WebSocket has been closed!");
}

// On load, retrieve the message by button trigger:
window.onload = function() {
	document.getElementById("sendButton").onclick = function() {
		w.send(document.getElementById("inputMessage").value);
	}
}

// Referenced from: http://stackoverflow.com/questions/155188/trigger-a-button-click-with-javascript-on-the-enter-key-in-a-text-box
function handleKeyPress(e) {
	if (e.keyCode === 13) {
		var sb = document.getElementById("sendButton");
		sb.click();
		return true;
	} else {
		return false;
	}
}

function displayMessage(s) {
	var logOutput = document.getElementById("logOutput");
	console.log("log: logOuput has been stored. ");

	// For debugging purposes:
	//console.log("log:" + s);
	var el = $("#msgOutput").before('<p>' + s + '</p>');
	//console.log(el);

	// Referenced from: https://github.com/mathiasbynens/jquery-placeholder/issues/19
	// Clear textarea and display placeholder:
	$('#inputMessage').val('').blur();
	$('#inputMessage').focus();
}
