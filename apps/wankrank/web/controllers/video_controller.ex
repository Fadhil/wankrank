defmodule Wankrank.VideoController do
  use Wankrank.Web, :controller
  alias Wankrank.Video

  @categories Application.get_env(:wankrank, :categories)

  plug :scrub_params, "video" when action in [:create, :update]
  plug :default_changeset, "video" when action in [:index, :new, :show]

  def index(conn, params) do
    query = from v in Video,
            order_by: [desc: v.wanks]
    videos = Repo.all(query)
    page = videos
    |> Wankrank.Repo.paginate(params)
    render(conn, "index.html", videos: videos)

  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    changeset = Video.changeset(%Video{}, video_params)
    case Repo.insert(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :edit, video.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset, categories: @categories)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Repo.get!(Video, id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  def default_changeset(conn, _key_values) do
    changeset = Video.changeset(%Video{})
    assign(conn, :changeset, changeset)
  end
end
