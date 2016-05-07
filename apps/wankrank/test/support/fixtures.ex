alias Plug.Anonymous

defmodule SomeApp do
  defmodule SomeController do
    use Plug.Builder
    plug Plug.Session,
      store: :cookie,
      key: "_wankrank_key",
      signing_salt: "cmwAUEpB",
      max_age: 86400
    plug :fetch_session
    plug Anonymous
  end
end
