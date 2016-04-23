defmodule Wankrank.VideoViewTest do
  use Wankrank.ConnCase, async: true

  alias Wankrank.VideoView

  test "returns embed code when given valid source and video_id" do
    embed_code = """
    <iframe width="250" height="220" src="videoID?showinfo=0" frameborder="0" allowfullscreen></iframe>
    """
    assert {:safe, embed_code}
      = VideoView.video_thumbnail(%Wankrank.Video{link: "somelink", video_id: "videoID", source: "youtube"})
  end
end
