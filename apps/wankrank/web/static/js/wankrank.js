import {Wankbutton} from "./wankbutton"
// Wankbutton click handler
$('.wankbutton').click(function(){
	Wankbutton.updateWank($(this).data('video-id'))	
})
