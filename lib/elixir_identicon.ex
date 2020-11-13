defmodule ElixirIdenticon do
  def main(input) do
  input
  |> hashInput
  |> pickColor
  |> buildGrid
  end

  def mirrorRow(row) do
    [ first, second | _tail ] = row
    row ++ [ second, first ]
  end

  def buildGrid(%ElixirIdenticon.Image{ hex:  hexList } = image) do
    grid = hexList
      |> Enum.chunk(3)
      |> Enum.map(&mirrorRow/1)
      |> List.flatten
      |> Enum.with_index

    %ElixirIdenticon.Image{ image | grid: grid }
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
