defmodule HomeworkWeb.Resolvers.CompaniesResolver do
  alias Homework.Companies
  alias Homework.Transactions

  @doc """
  List companies
  """
  def companies(_root, args, _info) do
    {:ok, Companies.list_companies(args)}
  end

  @doc """
  Get a company
  """
  def find_company(_root, %{id: id} = _args, _info) do
    {:ok, Companies.get_company!(id)}
  end

  @doc """
  Get available balance
  """
  def available_credit(company, _args, _info) do
    debits = Transactions.sum_for_company(company.id, :debit) || 0
    {:ok, company.credit_line - debits}
  end

  @doc """
  Create a new company
  """
  def create_company(_root, args, _info) do
    case Companies.create_company(args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not create company: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a company for an id with args specified.
  """
  def update_company(_root, %{id: id} = args, _info) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a company for an id
  """
  def delete_company(_root, %{id: id}, _info) do
    company = Companies.get_company!(id)

    case Companies.delete_company(company) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end
end
