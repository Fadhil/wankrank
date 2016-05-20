defmodule Plug.Anonymous do
  @moduledoc """
  This is the Anonymous Plug. It is designed for unobstructive sign up and
  sign in of users. The main idea is that people who visit certain sites
  might only ever use it anonymously and not want to sign in. For users who
  might be interested in actually trying out the site, they would normally
  have to jump through the whole user registration and sign up process.

  With Anonymous, however, a user is automatically created for the current
  visitor to the site, so that he may use the site almost as if he were
  full logged in (perhaps with certain restrictions on certain things,
  probably to be implemented with some sort of authorization plug)

  So a first time visitor would get a user generated with a random username
  and an anonymous_id (which will be stored in a session) and a `current_user`
  attribute will be added to the `conn` with the id of the newly created user.

  User should now be able to do basic and non destructive actions like
  comment on a page, view their auto-generated profile etc

  When a visitor updates his profile, and tries to save it, he will be prompted
  to enter a valid email (if he hasn't already done so in the profile edit)
  so the account can be associated with the visitor

  He can also choose to ignore that, for the time being, and NOT have his
  Account/Profile associated with his email. So long as he doesn't clear
  his browser, the he will have access to that account.

  If the cookies have been deleted, then a new anonymous user will be assigned.
  Supposing the user wanted to regain the account, he can go to sign in as
  another user. Sign up and Sign in are the same page. If the user signs in
  with a username that exists, and doesn't have an email attached to it, an
  error stating 'email required' will appear, and upon entering a valid email,
  a verification email will be sent to that address.

  Note, that no password has been set yet. Without a password, everytime a
  username and email combination are entered correctly, a verification email
  and a new anonymous_id will be generated, making sure that only the valid
  owner of an account can get it. Once an account logs in a second time using
  this verification message, we can prompt him to enter a password so he
  won't have to do that verification stuff anymore.
  """

  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  require Logger

  @doc ~S"""
  Initializes the Anonymous Plug
  """
  def init(options), do: options

  @doc ~S"""
  The callback for the plug
  """
  def call(conn, %{user_model: user_model, repo: repo}) do
    username = get_session(conn, "username")
    case username do
      nil ->
        conn
        |> create_anonymous_user(user_model, nil, repo)
      _ ->
        conn
        |> get_anonymous_user(user_model, repo, username )
    end
  end

  @doc ~S"""
  Creates a new Anonymous User if no `username` is found in the `session`.
  If a `username` is found in the `session`, and a User with a matching
  `username` field is found, that user will be returned as a `current_user`
  in the `conn`. If the `username` doesn't match any Users, a new anonymous
  user will be created and returned.
  """
  def get_anonymous_user(conn, user_model, repo, username) do
    Logger.debug "username: " <> username
    user = repo.one(from u in user_model, where: u.username== ^username)
    case user do
      nil -> conn = create_anonymous_user(conn, user_model, username, repo)
      _   ->
        conn = assign(conn, :current_user, user.id)
        |> put_session("username", user.username)

      conn
    end
  end

  @doc ~S"""
  Gets a user changeset from the given user_model and generates a fresh
  username for it
  """
  def user_changeset(user_model, nil, repo) do
    user_changeset = user_model.changeset(user_model.__struct__,
      %{
        username:     generate_username
      }
    )
  end

  @doc ~S"""
  Gets a user changeset from the given user_model and uses the given username
  for it
  """
  def user_changeset(user_model, username, repo) do
    user_changeset = user_model.changeset(user_model.__struct__,
      %{
        username:     username
      }
    )
  end

  def create_anonymous_user(conn, user_model, username, repo) do
    Logger.debug "Creating user!!"
    user_changeset = user_changeset(user_model, username, repo)
    Logger.debug "User changeset: " <> inspect(user_changeset)
    case repo.insert(user_changeset) do
      {:ok, user} ->
        conn = assign(conn, :current_user, user.id)
        |> put_session("username", user.username)
      {:error, changeset} ->
        conn = assign(conn, :current_user, "anonymous")
        |> put_session("username", generate_username)
    end
    conn
  end

  def generate_username do
    "SomeGenericWisdomyName"
  end
end
