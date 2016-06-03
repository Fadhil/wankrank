defmodule Wankrank.VideoTest do
  use Wankrank.ModelCase
  require IEx
  alias Wankrank.Video

  @valid_attrs %{"link" => "http://www.youtube.com/watch?v=e_ykAPDN7Uk"}
  @non_youtube_attrs %{"link" => "http://www.metacafe.com/watch/1295028/rubia/"}
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

  test "gets description from video page" do
    changeset = Video.new_changeset(%Video{}, @valid_attrs)
    assert changeset.changes.description =~ "Dangerous Woman"
  end

  # We'll want to change this eventually to allow videos from other sites
  test "returns changeset with errors if not youtube video" do
     changeset = Video.new_changeset(%Video{}, @non_youtube_attrs)
     refute changeset.valid?
  end
end
