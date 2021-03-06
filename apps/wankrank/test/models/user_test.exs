defmodule Wankrank.UserTest do
  use Wankrank.ModelCase

  alias Wankrank.User

  @valid_attrs %{username: "SomeUserName"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
