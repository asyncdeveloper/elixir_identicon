defmodule ElixirIdenticon do
  def main(input) do
  input
  |> hashInput
  |> pickColor
  |> buildGrid
  |> filterOdd
  |> buildPixelMap
  |> drawImage
  |> saveImage(input)
  end

  def saveImage(image, input) do
    File.write("#{input}.png", image)
  end

  def drawImage(%ElixirIdenticon.Image{ color:  color , pixel_map: pixelMap }) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixelMap, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def buildPixelMap(%ElixirIdenticon.Image{ grid:  grid } = image) do
    pixelMap = Enum.map grid, fn ({ _value , index }) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      topLeft = { horizontal, vertical }
      bottomRight = { horizontal+50, vertical+50}

      { topLeft, bottomRight }
    end

    %ElixirIdenticon.Image{ image | pixel_map: pixelMap }
  end

  def filterOdd(%ElixirIdenticon.Image{ grid:  grid } = image) do
    filteredGrid = Enum.filter grid, fn ({ value , _index }) ->
      rem(value, 2) == 0
    end

    %ElixirIdenticon.Image{ image | grid: filteredGrid }
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
