defmodule NameGeneratorTest do
  use ExUnit.Case, async: true
  alias Wankrank.NameGenerator

  test "returns a random username made of three words and a number" do
    # Three words CamelCased
    regex = ~r([A-Z]\w*[A-Z]\w*[A-Z]\w*-\d{4})
    assert Regex.match?(regex, NameGenerator.generate)
  end
end
