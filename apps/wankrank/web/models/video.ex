defmodule Wankrank.Video do
  use Wankrank.Web, :model
  require IEx

  schema "videos" do
    field :title, :string
    field :link, :string
    field :description, :string
    field :video_id, :string
    field :source, :string
    field :wanks, :integer, default: 0
    field :category, :string
    timestamps
  end

  @required_fields ~w(link)
  @optional_fields ~w(title description video_id wanks source category)

  @http_client Application.get_env(:wankrank, :http_client)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> embed_video(params)
    |> extract_details
  end

  defp embed_video(video_changeset, params \\ :empty) do
    case get_video_link(params) do
      {:ok, video_link} ->
        video_id = get_video_id(video_link)
        source = get_video_source(video_link)
        {change(video_changeset, video_id: video_id, source: source), video_link: video_link}
      {:error, error_message} ->
        add_error(video_changeset, :link, error_message)
    end
  end

  def get_video_link(params) do
    case params do
     :empty -> {:error, "No link"}
     %{"link" => video_link} when video_link in [" ", "", nil] ->
       {:error, "No link"}
     %{"link" => video_link} ->
       case get_video_source(video_link) do
         "youtube" -> {:ok, video_link}
         "unknown" -> {:error, "Video must be hosted on Youtube"}
       end
     _ -> {:error, "Something went wrong"}
    end
  end


  def extract_details({video_changeset,[video_link: video_link]}) do
    case video_link do
      video_link when video_link in [" ", "", nil] -> video_changeset
      _ ->
        %{body: video_body} = @http_client.get!(video_link)
        [{"meta", [{"name", "title"}, {"content", title}], _}] = Floki.find(video_body, "meta[name=title]")
        description = get_video_description(:youtube, video_body)
        change(
          video_changeset, title: title, description: description
         )
    end
  end

  def extract_details(video_changeset) do
    video_changeset
  end

  def get_video_description(source_site, video_body) do
    case source_site do
      :youtube ->
        Floki.find(video_body, "p[id=eow-description]")
        |> Floki.raw_html
      _ -> nil
    end
  end

  def get_video_id(video_link) do
    regex_result = Regex.named_captures(~r/.*youtube.com\/watch\?v=(?<video_id>\w*)&?/, video_link)
    case regex_result do
      nil -> nil
      %{"video_id" => video_id} -> video_id
    end
  end

  def get_video_source(video_link) do
    case Regex.match?(~r/youtube\.com/, video_link) do
      true -> "youtube"
      false -> "unknown"
    end
  end
end
