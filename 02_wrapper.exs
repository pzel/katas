#!/bin/env elixir
ExUnit.start()

defmodule Wrapper do
  def wrap(string, columns) when is_binary(string) do
    string
    |> String.splitter(" ", trim: true)
    |> Enum.reduce([""], fn w,acc -> formatter(w, acc, columns) end)
    |> Enum.reverse()
    |> :erlang.iolist_to_binary()
  end

  defp formatter(w, [line|acc], columns) do
    case {String.length(w), String.length(line)} do
      {word_len, _} when word_len > columns ->
        # Single word is longer than we can fit in a line.
        # Break it up at `columns` as many times as required.
        lines = split_single_word(w, columns)
        ["" | [lines | [line <> "\n"| acc ]]]
      {word_len, line_len} when line_len+word_len >= columns ->
        # Adding this word to the line would exceed columns,
        # Add a NL to the current line and start a new line.
        [w | [ line <> "\n" | acc]]
      {_, 0} ->
        # First word in a line
        [w | acc ]
      {_, _} ->
        # Add a space, then the word
        [line <> " " <> w | acc ]
    end
  end

  defp split_single_word(word, columns) do
    chunks = Regex.compile!(".{#{columns}}+")
      |> Regex.split(word, include_captures: true, trim: true)
    case String.length(List.last(chunks))+1 == columns do
      true -> Enum.join(chunks, "\n")
      false -> Enum.join(chunks, "\n") <> "\n"
    end
  end
end


defmodule WrapperTest do
  use ExUnit.Case

  test "it doesn't wrap when column is longer than text" do
    assert "hello world" == Wrapper.wrap("hello world", 12)
  end

  test "it wraps at nearest word boundary" do
    assert "hello\nworld" == Wrapper.wrap("hello world", 6)
  end

  test "it wraps at nearest word boundary repeatedly" do
    assert "hello\nworld\nhello\nworld" ==
      Wrapper.wrap("hello world hello world", 6)
  end

  test "it preserves punctuation" do
    assert "hi,\nworld!" ==
      Wrapper.wrap("hi, world!", 6)
  end

  test "it breaks word in half if it's longer than columns" do
    assert "hi,\nsaggit\narius" ==
      Wrapper.wrap("hi, saggitarius", 6)
  end

  test "it breaks word into multiple lines if it's columns++" do
    want = ["you",
            "tyrr",
            "anos",
            "auru",
            "srex",
            ",",
            "you"]|> Enum.join("\n")

    assert want == Wrapper.wrap("you tyrranosaurusrex, you", 4)
  end


end
