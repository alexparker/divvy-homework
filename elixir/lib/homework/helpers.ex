defmodule Homework.Helpers do
  @moduledoc """
  Generic helper methods and macros
  """

  @doc """
  Compares target, input string to given levenshtein threshold
  """
  defmacro levenshtein(source, target, threshold) do
    quote do
      levenshtein(unquote(source), unquote(target)) <= unquote(threshold)
    end
  end

  @doc """
  Return a query fragment of case insensitive levenshtein calculationo
  """
  defmacro levenshtein(source, target) do
    quote do
      fragment(
        "levenshtein(LOWER(?), LOWER(?))",
        unquote(source),
        unquote(target)
      )
    end
  end
end
