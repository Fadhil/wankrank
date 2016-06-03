function updateWank(payload){
    let wankcount= $('span [data-video-id='+ payload.video_id +']')
    wankcount.hide()
    wankcount.html(payload.wank_count).fadeIn()
    // wankcount.delay(100).fadeIn()
    console.log("Video " + payload.video_id + " clicked " + payload.wank_count + " times")
  }

export var Wankbutton = {
  updateWank: updateWank
}
