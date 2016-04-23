$(document).ready(function(){
  alert('ehhl');
});


$("#video_link").on('keydown', function(event) {
  var currentString = $("#video_link").value;
  console.log("hello");
  $("#video_link").html(currentString.length);
  if (currentString.length > 0 )  {  /*or whatever your number is*/
    display:block;
  } else {
    display:none;
  }
});


