defmodule Wankrank.VideoView do
  use Wankrank.Web, :view
  import Scrivener.HTML
  def video_thumbnail %Wankrank.Video{link: link, video_id: nil} do
    link
  end

  def video_thumbnail %Wankrank.Video{link: link, video_id: ""} do
    link
  end

  def video_thumbnail %Wankrank.Video{link: link, video_id: video_id, source: source} do
    raw embed_link(source, video_id)
  end

  def video_show %Wankrank.Video{link: link, video_id: video_id, source: source} do
    raw embed_link(source, video_id, :normal)
  end


  def title %Wankrank.Video{title: title} do
    title || "n/a"
  end

  def display_title(conn) do
    case Map.has_key?(conn.assigns, :search_terms) do
      true -> "Showing results for: '"<> conn.assigns.search_terms <> "'"
      false -> "Listing Videos"
    end
  end


  def description %Wankrank.Video{description: description} do
    case description do
      description when description in [" ", "", nil] ->
        {"n/a", "hidden"}
      description -> {description, ""}
    end
  end

  def embed_link("youtube", video_id, size \\ :thumbnail) do
    dimensions = case size do
      :normal->
        %{width: 360, height: 240}
      :large ->
        %{width: 640, height: 480}
      _ -> %{width: "100%", height: "100%"}
    end
    """
    <iframe width="#{dimensions.width}" height="#{dimensions.height}" src="http://youtube.com/embed/#{video_id}?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
    """
  end

  def downcase_and_dash(category) do
    category
    |> String.downcase
    |> String.split(" ")
    |> Enum.join("-")
  end

end
