defmodule Wankrank.VideoController do
  use Wankrank.Web, :controller
  alias Wankrank.Video
  @categories Application.get_env(:wankrank, :categories)
	@admin_password System.get_env("WANKRANK_ADMIN_PASSWORD")

  plug :scrub_params, "video" when action in [:create, :update]
  plug :default_changeset, "video" when action in [:index, :new, :show]

	def index(conn, params = %{"search" => %{"terms" => search_terms}}) do
		wildcard_search_terms = search_terms
			|> String.split(" ")
			|> Enum.filter(fn word -> String.length(word) > 2 end) # Only take words longer than 2 chars
			|> Enum.join("%") # SQL queries use % for wildcard search

		# Add % to beginning and end
		wildcard_search_terms = "%" <> wildcard_search_terms <> "%"
    query = from v in Video,
						where: like(v.title, ^wildcard_search_terms), # ^ to refer to previously declared var
            order_by: [desc: v.wanks],
						limit: 1
    page = query
    |> Wankrank.Repo.paginate(params)

		case page.total_entries do
			0 ->
        conn
        |> put_flash(:error, "No videos matching your search terms.")
        |> redirect(to: video_path(conn, :index))
			_ ->
				render(conn, "index.html", videos: page.entries,
				 page: page,
				 category: "",
				 search_terms: search_terms
			 )
		end
	end

  def index(conn, params) do
    query = from v in Video,
            order_by: [desc: v.wanks]
    page = query
    |> Wankrank.Repo.paginate(params)
    render(conn, "index.html", videos: page.entries,
     page: page,
     category: "")

  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render(conn, "new.html", changeset: changeset, categories: @categories)
  end

  def create(conn, %{"video" => video_params,
		"admin" => %{"password" => @admin_password }}) do
    changeset = Video.new_changeset(%Video{}, video_params)
    case Repo.insert(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :edit, video.id))
      {:error, changeset} ->
				case changeset.errors do
					[video_id: "has already been taken"] ->
						video = Repo.get_by(Video, video_id: changeset.changes.video_id)
						conn
						|> put_flash(:info, "Video already exists")
						|> redirect(to: video_path(conn, :show, video.id ))
					_ ->
						render(conn, "new.html", changeset: changeset, categories: @categories)
				end
    end
  end

  def create(conn, %{"video" => video_params}) do
		changeset = Video.new_changeset(%Video{}, video_params)
		conn
		|> put_flash(:info, "You need a password to upload videos. Please contact the admins at wankrank@yahoo.com to get your password.")
		|> render("new.html", changeset: changeset, categories: @categories)
  end


  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.html", video: video, categories: @categories)
  end

  def edit(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset, categories: @categories)
  end

  def categories(conn, params = %{"category" => category}) do
    video_category = case category do
      "music-videos" -> "Music Videos"
      "celebrities" -> "Celebrities"
      "personalities" -> "Personalities"
      _ -> :error
    end
    if :error == video_category do
      conn
      |> put_flash(:error, "Path Not Found")
      |> redirect(to: video_path(conn, :index))

    else
      query = from v in Video,
              where: v.category == ^video_category,
              order_by: [desc: v.wanks]
      page = query
      |> Wankrank.Repo.paginate(params)
      render(conn, "categories.html", videos: page.entries,
       categories: @categories,
       page: page,
       category: video_category)
    end
  end

  def update(conn, %{"id" => id, "video" => video_params,
		"admin" => %{"password" => @admin_password}}) do

    video = Repo.get!(Video, id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset, categories: @categories)
    end
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
			video = Repo.get!(Video, id)
			changeset = Video.changeset(video, video_params)
			conn
			|> put_flash(:info, "You need a password to update videos. Please contact the admins at wankrank@yahoo.com to get your password.")
      |>  render("edit.html", video: video, changeset: changeset, categories: @categories)
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
