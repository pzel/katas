#!/bin/env elixir
ExUnit.start()

defmodule Histogram do
  def new(word) when is_binary(word) do
    Enum.reduce(String.to_charlist(word),
      %{},
      fn char, hist ->
        Map.update(hist, char, 1, &(&1+1))
      end)
  end

  def reciprocal(hist, w1) do
    w1_hist = new(w1)
    out = Map.merge(hist, w1_hist, fn _k, hist_val, w1_val ->
      hist_val - w1_val
    end)
    case Enum.count(out) == Enum.count(hist) do
      false -> nil
      true ->
        {w1_hist,
         Enum.filter(out, fn{_,v} -> v != 0 end) |>
           Enum.into(%{})}
    end
  end
end

defmodule Anagrams do
  def of(word, vocab) do
    root = Histogram.new(word)
    words = String.split(vocab, [" ", "\n"], trim: true)
    cross = build_cross_index(root, words)
    pairs = find_pairs(cross)
    Enum.reduce(pairs, MapSet.new(), fn pair, set ->
      MapSet.put(set, Enum.sort(pair))
    end)
  end

  defp find_pairs(cross_index) do
    Enum.flat_map(cross_index,
      fn {_k, vs} ->
        Enum.flat_map(vs, fn {word, recip} ->
          case Map.get(cross_index, recip) do
            nil -> []
            wordrecips ->
              Enum.map(wordrecips,
                fn {reciprocal,_} -> [word, reciprocal] end)
          end
        end)
      end)
  end

  defp build_cross_index(root, words) do
    Enum.reduce(words, %{}, fn word, acc ->
      case Histogram.reciprocal(root, word) do
        nil ->
          acc
        {w_hist, recip} ->
          entry = {word, recip}
          Map.update(acc, w_hist, [entry],
            fn entries -> [entry|entries] end)
      end
    end)
  end
end

defmodule AnagramViaPermutations do
  # This works only for short words, as the number of permutations is
  # factorial(length(word)).
  def of(word, dict_file_contents) when is_binary(word) do
    real_words = String.split(dict_file_contents, [" ", "\n"],
      trim: true)
      |> MapSet.new()
    perms = permutations(" " <> word)
    Enum.reduce(perms, MapSet.new(), fn perm, found ->
      case String.split(perm, " ", trim: true) do
        [w1,w2] ->
          MapSet.member?(real_words, w1) &&
            MapSet.member?(real_words, w2) &&
             MapSet.put(found, Enum.sort([w1,w2])) ||
            found
        _ ->
          found
      end
    end)
  end

  def permutations(""), do: [[]]
  def permutations(<<h::utf8>>), do: [<<h>>]
  def permutations(string) when is_binary(string) do
    charlist = String.to_charlist(string)
    f = fn el ->
      Enum.map(permutations("#{List.delete(charlist, el)}"),
        fn perm -> <<el::utf8, perm::binary>> end)
    end
    Enum.flat_map(charlist, f)
  end
end

defmodule AnagramTests do
  use ExUnit.Case

  test "histogram builds a count of chars" do
    h1 = Histogram.new("aza")
    h2 = Histogram.new("zaa")
    assert h1 == h2
  end

  test "reciprocal builds a complementary (wanted) histogram" do
    h1 = Histogram.new("aza")
    {_h2, rec} = Histogram.reciprocal(h1, "a")
    want = Histogram.new("za")
    assert want == rec
  end

  test "reciprocal returns nil if reciprocal doesn't make sense" do
    h = Histogram.new("aza")
    assert nil == Histogram.reciprocal(h, "g")
  end

  test "it generates a list of single letter 2-word anagrams for word" do
    wordlist = "a b"
    assert MapSet.new([["a", "b"]]) == Anagrams.of("ba", wordlist)
  end

  test "it generates a list of 2-word anagrams for word" do
    wordlist = "a b c aa bb cc ab ba"
    assert MapSet.new([
      ["aa", "bb"],
      ["ab", "ba"],
      ["ab", "ab"], # these can be eliminated,
      ["ba", "ba"]  # but I think it's correct to have them
    ]) == Anagrams.of("baba", wordlist)
  end

  test "it generates multiple 2-word anagrams for word" do
    want = MapSet.new([
              ["ab", "alone"],
              ["aloe", "ban"],
              ["aloe", "nab"],
              ["baa", "lone"],
              ["baa", "noel"],
              ["boa", "elan"],
              ["boa", "lane"],
              ["boa", "lean"],
              ["bola", "nae"]
              ])
    word_list = File.read!("/usr/share/dict/words")
    assert want == Anagrams.of("abalone", word_list)
  end

  test "it generates multiple 2-word anagrams for long word" do
    word_list = File.read!("/usr/share/dict/words")
    pairs = Anagrams.of("documenting", word_list) |> IO.inspect()
    target = Enum.sort(String.to_charlist("documenting"))
    Enum.each(pairs, fn [a,b] ->
      assert Enum.sort(String.to_charlist(a<>b)) == target
    end)
  end
end
