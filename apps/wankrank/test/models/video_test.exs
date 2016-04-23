defmodule Wankrank.VideoTest do
  use Wankrank.ModelCase

  alias Wankrank.Video

  @valid_attrs %{"description" => "some content", "link" => "http://www.youtube.com/watch?v=e_ykAPDN7Uk"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "video_id should be generated from link" do
    youtube_link = "https://www.youtube.com/watch?v=videoID"
    assert "videoID" = Video.get_video_id(youtube_link)
  end

  test "gets source from video link" do
    youtube_link = "https://www.youtube.com/watch?v=videoID"
    assert "youtube" = Video.get_video_source(youtube_link)
  end
end
