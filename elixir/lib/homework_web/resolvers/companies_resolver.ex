defmodule HomeworkWeb.Resolvers.CompaniesResolver do
  alias Homework.Companies
  alias Homework.Transactions

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
    debits = Transactions.sum_for_company(company.id, :debit)
    {:ok, company.credit_line - debits}
  end
end
