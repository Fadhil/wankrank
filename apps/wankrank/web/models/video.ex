defmodule Wankrank.Video do
  use Wankrank.Web, :model

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

  @required_fields ~w(link category)
  @optional_fields ~w(title description video_id wanks source)

  @http_client Application.get_env(:wankrank, :http_client)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def new_changeset(model, params \\ :empty) do
    changeset(model, params)
    |> validate_format(
      :link,
      ~r/.*youtube\.com.*/, message: "Video must be hosted on youtube.")
    |> unique_constraint(:video_id)
    |> embed_video(params)
    |> extract_details
  end

  defp embed_video(video_changeset, params \\ :empty) do
    case get_video_link(params) do
      {:ok, video_link} ->
        video_id = get_video_id(video_link)
        source = get_video_source(video_link)
        {change(video_changeset, video_id: video_id, source: source), video_link: video_link, source: source}
      {:error, _} ->
        video_changeset
    end
  end

  defp get_video_link(params) do
    case params do
     :empty -> {:error, "No link"}
     %{"link" => video_link} when video_link in [" ", "", nil] ->
       {:error, "No link"}
     %{"link" => video_link} -> {:ok, video_link}
     _ -> {:error, "Something went wrong"}
    end
  end


  def extract_details({video_changeset,[video_link: video_link, source: source]}) do
    case source do
      "youtube" ->
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
      _ -> video_changeset
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
    case Regex.named_captures(~r/.*youtube.com\/watch\?v=(?<video_id>\w*)&?/, video_link) do
      %{"video_id" => video_id} -> video_id
      _ -> nil
    end
  end

  def get_video_source(video_link) do
      case Regex.match?(~r/youtube\.com/, video_link) do
        true -> "youtube"
        _ -> "unknown"
    end
  end
end
