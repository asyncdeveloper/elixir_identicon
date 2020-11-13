defmodule ElixirIdenticon do
  def main(input) do
  input
  |> hashInput
  |> pickColor
  end

  def pickColor(image) do
    %ElixirIdenticon.Image{ hex:  [ red, green, blue | _tail ] } = image
    %ElixirIdenticon.Image{ image | color: {red, green, blue }}
  end

  def hashInput(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %ElixirIdenticon.Image{hex: hex}
  end
end
