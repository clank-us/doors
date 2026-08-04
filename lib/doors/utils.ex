defmodule Doors.Utils do
  @alg_map %{
    "S256" => :sha256,
    :S256 => :sha256,
    :sha256 => :sha256
  }

  def hash_encode(data, alg), do: data |> hash(alg) |> encode()
  def random_encode(length \\ 16), do: length |> random() |> encode()

  # Common, foundational utilities
  def hash(data, alg), do: Map.fetch!(@alg_map, alg) |> :crypto.hash(data)
  def random(length), do: :crypto.strong_rand_bytes(length)
  def encode(data), do: Base.url_encode64(data, padding: false)
  def decode(data), do: Base.url_decode64(data, padding: false)
end
