defmodule Wankrank.HTTPTestClient do
  def get!(_video_link) do
    File.read!("test/support/youtube-ariana-response.poison")
    |> :erlang.binary_to_term
  end
end
