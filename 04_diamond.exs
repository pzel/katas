#!/bin/env elixir

# DIAMOND http://codingdojo.org/kata/Diamond/
#
# Given a letter, print a diamond starting with ‘A’ with
# the supplied  at the widest point.
#
#  A
# B B
#C   C
# B B
#  A

ExUnit.start()
defmodule DiamondTest do
  use ExUnit.Case

  test "diamond with A just prints A" do
    assert Diamond.of(?A) == "A\n"
  end

  test "diamond with B" do
    want = """
 A
B B
 A
"""
    assert Diamond.of(?B) == want
  end

  test "diamond with C" do
    want = """
  A
 B B
C   C
 B B
  A
"""
    assert Diamond.of(?C) == want
  end

  test "diamond with D" do
    want = """
   A
  B B
 C   C
D     D
 C   C
  B B
   A
"""
    assert Diamond.of(?D) == want
  end

end


defmodule Diamond do
  @letters ?A..?Z
  def of(letter) when letter in @letters do
    (?A .. letter)
    |> Enum.map(&(flatten(letter_line(&1, letter))))
    |> mirror()
    |> flatten()
  end

  defp flatten(x), do: :erlang.iolist_to_binary(x)

  defp letter_line(?A, max) do
    [leading_space(?A, max), "A\n"]
  end
  defp letter_line(l, max) do
    [leading_space(l,max), l , inner_space(l), l, "\n"]
  end

  defp leading_space(l, max) do
    spaces(normalize(max) - normalize(l))
  end

  defp inner_space(l), do: spaces(normalize(l) * 2 - 1)

  defp spaces(n), do: List.duplicate(' ', n)

  defp normalize(letter), do: letter - ?A

  defp mirror(list), do: list ++ tl(Enum.reverse(list))

end
