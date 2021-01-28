defmodule Homework.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  import Homework.Helpers

  alias Homework.Repo
  alias Homework.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users([])
      [%User{}, ...]

  """
  def list_users(%{search: search_query}) do
    fuzzymatch_users(search_query, 2)
  end

  def list_users(_args) do
    Repo.all(User)
  end

  @doc """
  Returns a list of fuzzy matched users

  Matches values(first and last names) that start with the search query
  Then performs levenshtein fuzzy match on first and last names

  For Divvy:
    I am super picky about search features, and don't usually love mediocre solutions like this.
    But this is how I'd proably prefer to ship a first version, then plan the best way to serve
    the desired UX of the customers and what they expect of search.

  ## Examples

    iex> fuzzymatch_users("bobert", 3)
    [%User{first_name: "Robert"}, ...]

  """
  def fuzzymatch_users(search, threshold) do
    starts_with = "#{search}%"

    query =
      from(
        u in User,
        where:
          ilike(u.first_name, ^starts_with) or
            ilike(u.last_name, ^starts_with) or
            levenshtein(u.first_name, ^search, ^threshold) or
            levenshtein(u.last_name, ^search, ^threshold),
        order_by: [
          desc: fragment("strpos(lower(?), lower(?))", u.first_name, ^search) - 1,
          desc: fragment("strpos(lower(?), lower(?))", u.last_name, ^search) - 1,
          asc:
            fragment(
              "LEAST(?, ?)",
              levenshtein(u.first_name, ^search),
              levenshtein(u.last_name, ^search)
            )
        ]
      )

    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
