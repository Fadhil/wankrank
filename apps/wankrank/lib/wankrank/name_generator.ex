defmodule Wankrank.NameGenerator do
  @adjectives ~w(
    Big Small Large Massive Gargantuan Tiny Miniscule Minute Wide Tall Short
    Slim
  )
  @attributes ~w(
    Strong Wild Fierce Crazy Insane Mad Horrific Terrible Greedy Lustful
    Rabid Blasphemous
  )
  @nouns ~w(
    Lion Tiger Tapir Rabbit Goat Rooster Dragon Bull Dog Pig Rat Raccoon
    Alligator Crocodile Shark Whale Dolphin Eagle Condor Hawk Wolf Deer Hyena
  )
  def generate do
    # Seed :random so it's a bit more random than usual
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    name = [@adjectives, @attributes, @nouns]
    |> Enum.map(fn word_list -> Enum.random(word_list) end)
    |> Enum.join("")
    name_id = Enum.random(1..9999) |> to_string |> String.rjust(4, ?0)
    name <> "-" <> name_id
  end
end

