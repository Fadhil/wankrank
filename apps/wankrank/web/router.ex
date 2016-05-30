defmodule Wankrank.Router do
  use Wankrank.Web, :router
  alias Plug.Anonymous

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Anonymous, %{
      user_model: Wankrank.User,
      repo: Wankrank.Repo
    }
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wankrank do
    pipe_through :browser # Use the default browser stack

    get "/", VideoController, :index
    post "/", VideoController, :index
    resources "/users", UserController
    resources "/videos", VideoController
    get "/:category", VideoController, :categories
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wankrank do
  #   pipe_through :api
  # end
end
