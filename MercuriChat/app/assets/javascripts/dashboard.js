// Code for general purpose Dashboard layout:
// Start a new WebSocket:

//= require jquery-ui/autocomplete
//= require jquery-ui/dialog

//Autocomplete for search form. 
$(function(){
    $('#find_friend').autocomplete({
        source: gon.users
    }); 
});

function display_groupwin() {
    document.getElementById("newgroup").style.display = "block"
    $( "#newgroup" ).dialog();
};
  
//Submitting a form with no submit button referenced from
//http://stackoverflow.com/questions/699065/submitting-a-form-on-enter-with-jquery
$(".searchbox").keypress(function(e)
{
    if (e.which == 13)
    {
      $('.form').submit();
      return false   
    }
});

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
