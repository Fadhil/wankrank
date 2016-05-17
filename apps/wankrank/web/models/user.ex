defmodule Wankrank.User do
  use Wankrank.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :username, :string
    timestamps
  end

  @required_fields ~w(username)
  @optional_fields ~w(name email)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
