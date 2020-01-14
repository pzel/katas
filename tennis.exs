#!/usr/bin/env elixir
ExUnit.start()

defmodule Tennis do
  def new, do: {0,0}
  def point({l, r}, Left) when l in [0,15,30], do: check_for_deuce({next(l), r})
  def point({l, r}, Right) when r in [0,15,30], do: check_for_deuce({l, next(r)})
  def point({40, _}, Left), do: {Win, Left}
  def point({_, 40}, Right), do: {Win, Right}

  def point(Deuce, side), do: {Advantage, side}
  def point({Advantage, side}, side), do: {Win, side}
  def point({Advantage, _other_side}, _side), do: Deuce

  defp next(p), do: %{0 => 15, 15 => 30, 30 => 40}[p]
  defp check_for_deuce({40,40}), do: Deuce
  defp check_for_deuce(score), do: score
end


defmodule TennisTests do
  use ExUnit.Case

  test "left player can score up to 40" do
    g = Tennis.new()
    {15,0} = g1 = Tennis.point(g, Left)
    {30,0} = g2 = Tennis.point(g1, Left)
    {40,0} = Tennis.point(g2, Left)
  end

  test "left player can win" do
    g = Tennis.new()
    {15,0} = g1 = Tennis.point(g, Left)
    {30,0} = g2 = Tennis.point(g1, Left)
    {40,0} = g3 = Tennis.point(g2, Left)
    {Win, Left} = Tennis.point(g3, Left)
  end

  test "right player can win" do
    g = Tennis.new()
    {0,15} = g1 = Tennis.point(g, Right)
    {0,30} = g2 = Tennis.point(g1, Right)
    {0,40} = g3 = Tennis.point(g2, Right)
    {Win, Right} = Tennis.point(g3, Right)
  end

  test "both players at 40 is deuce" do
    g = {30,30}
    {40,30} = g1 = Tennis.point(g, Left)
    Deuce = Tennis.point(g1, Right)
  end

  test "left player score on deuce is left_advantage" do
    g = Deuce
    {Advantage, Left} = Tennis.point(g, Left)
  end

  test "right player score on deuce is right_advantage" do
    g = Deuce
    {Advantage, Right} = Tennis.point(g, Right)
  end

  test "left player score on left_advantage is left win" do
    g = {Advantage, Left}
    {Win, Left} = Tennis.point(g, Left)
  end

  test "right player score on left_advantage is deuce" do
    g = {Advantage, Left}
    Deuce = Tennis.point(g, Right)
  end

  test "right player score on right advantage is right win" do
    g = {Advantage, Right}
    {Win, Right} = Tennis.point(g, Right)
  end

  test "left player score on right advantage is deuce again" do
    g = {Advantage, Right}
    Deuce = Tennis.point(g, Left)
  end

  test "illegal moves are function clause errors" do
    g = {Advantage, Right}
    g1 = Tennis.point(g, Right)
    assert_raise FunctionClauseError, fn -> Tennis.point(g1, Right) end
  end

end
