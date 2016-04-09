// Code for general purpose Dashboard layout:

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
