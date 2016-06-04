function updateWank(payload){
  let wankcount= $('span[data-video-id='+ payload.video_id +']')
  wankcount.hide()
  wankcount.html(payload.wank_count).fadeIn()
}

function updateVideoPosition(payload){
  let thisVideoLi = $('li[data-video-id='+ payload.video_id + ']')
  let prevVideoLi = thisVideoLi.prev()
  // Get the previous Video's id from it's 'data-video-id' info
  let prevVideoId = prevVideoLi.data('video-id')
  
  // Let's compare each this video and the previous video's wankcount
  let thisVideoWankCount = payload.wank_count // Use updated wankcount
  let prevVideoWankCount = $('span[data-video-id=' + prevVideoId + ']').text()
  if(thisVideoWankCount > prevVideoWankCount){
    // First we hide both videos li's
    thisVideoLi.hide()
    prevVideoLi.hide()

    // Then we switch positions (this video with more wanks should be before)
    // Not too sure why 'after' seems to be the behaviour we're looking for
    thisVideoLi.after(prevVideoLi)
    
    // Then fade in both videos
    thisVideoLi.fadeIn() 
    prevVideoLi.fadeIn()
  }

}

export var Wankbutton = {
  updateWank: updateWank,
  updateVideoPosition: updateVideoPosition
}
