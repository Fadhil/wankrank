defmodule Wankrank.VideoView do
  use Wankrank.Web, :view
  require IEx

  def video_thumbnail %Wankrank.Video{link: link, video_id: nil} do
    link
  end

  def video_thumbnail %Wankrank.Video{link: link, video_id: ""} do
    link
  end

  def video_thumbnail %Wankrank.Video{link: link, video_id: video_id, source: source} do
    raw embed_link(source, video_id)
  end

  def title %Wankrank.Video{title: title} do
    title || "n/a"
  end


  def description %Wankrank.Video{description: description} do
    case description do
      description when description in [" ", "", nil] ->
        {"n/a", "hidden"}
      description -> {description, ""}
    end
  end

  def embed_link("youtube", video_id) do
    """
    <iframe width="250" height="220" src="http://youtube.com/embed/#{video_id}?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
    """
  end

end
