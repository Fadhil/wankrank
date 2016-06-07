function updateWank(payload){
  let wankcount= $('span[data-video-id='+ payload.video_id +']')
  wankcount.hide()
  wankcount.html(payload.wank_count).fadeIn()
}

function updateVideoPosition(video_id){
  let thisVideoLi = $('li[data-video-id='+ video_id + ']')
  let prevVideoLi = thisVideoLi.prev()
  // Get the previous Video's id from it's 'data-video-id' info
  let prevVideoId = prevVideoLi.data('video-id')
  
  // Let's compare each this video and the previous video's wankcount
  let thisVideoWankCount = $('span[data-video-id=' + video_id + ']').text()
  let prevVideoWankCount = $('span[data-video-id=' + prevVideoId + ']').text()
  if (parseInt(thisVideoWankCount) > parseInt(prevVideoWankCount)){
    // First we hide both videos li's
    thisVideoLi.hide()
    prevVideoLi.hide()

    // Then we switch positions (this video with more wanks should be before)
    // Not too sure why 'after' seems to be the behaviour we're looking for
    thisVideoLi.after(prevVideoLi)
    
    // Then fade in both videos
    thisVideoLi.fadeIn() 
    prevVideoLi.fadeIn()

    // Now, thisVideo has moved to before prevVideo (although we used after, weird)
    // So there should be a new prevVideo (the video *previous* to the first
    // prevVideo), so we'll run updateVideoPosition again with thisVideo's id
    // and if the new prevVideo is less than thisVideo's wankcount, it'll 
    // switch places again. This technically should work for as many videos
    // that have the same wankcount
    updateVideoPosition(video_id) 
   
  }

}

export var Wankbutton = {
  updateWank: updateWank,
  updateVideoPosition: updateVideoPosition
}
