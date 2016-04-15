<<<<<<< HEAD
// Referenced from "The Definitive Guide to HTML5 WebSocket"
// Start a new WebSocket

//= require jquery
//= require jquery_ujs

$( "#searchbox" ).autocomplete({
    source: gon.users
});
  
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
=======
// Code for general purpose Dashboard layout:
>>>>>>> 697ba6b1c84dfce54b44f48b5dc31260997473f3

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
