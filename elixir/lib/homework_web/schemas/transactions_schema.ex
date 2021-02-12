defmodule HomeworkWeb.Schemas.TransactionsSchema do
  @moduledoc """
  Defines the graphql schema for transactions.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.TransactionsResolver

  scalar :currency, name: "Currency" do
    serialize(&serialize_amount_to_dollars/1)
    parse(&parse_amount_to_cents/1)
  end

  object :transaction do
    field(:id, non_null(:id))
    field(:user_id, :id)
    field(:amount, :currency)
    field(:credit, :boolean)
    field(:debit, :boolean)
    field(:description, :string)
    field(:merchant_id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:user, :user) do
      resolve(&TransactionsResolver.user/3)
    end

    field(:merchant, :merchant) do
      resolve(&TransactionsResolver.merchant/3)
    end
  end

  object :transaction_mutations do
    @desc "Create a new transaction"
    field :create_transaction, :transaction do
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      @desc "amount is in cents"
      arg(:amount, non_null(:currency))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))
      arg(:company_id, non_null(:id))

      resolve(&TransactionsResolver.create_transaction/3)
    end

    @desc "Update a transaction"
    field :update_transaction, :transaction do
      arg(:id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      @desc "amount is in cents"
      arg(:amount, non_null(:currency))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))
      arg(:company_id, non_null(:id))

      resolve(&TransactionsResolver.update_transaction/3)
    end

    @desc "delete an existing transaction"
    field :delete_transaction, :transaction do
      arg(:id, non_null(:id))

      resolve(&TransactionsResolver.delete_transaction/3)
    end
  end

  defp serialize_amount_to_dollars(amount) do
    amount
    |> Decimal.div(100)
    |> Decimal.round(2)
    |> Decimal.to_string()
  end

  defp parse_amount_to_cents(%Absinthe.Blueprint.Input.Integer{value: value}) do
    {:ok, value * 100}
  end

  defp parse_amount_to_cents(%Absinthe.Blueprint.Input.String{value: value}) do
    cents =
      value
      |> Decimal.mult(100)
      |> Decimal.to_integer()

    {:ok, cents}
  end

  defp parse_amount_to_cents(%Absinthe.Blueprint.Input.Float{value: value}) do
    cents =
      value
      |> Decimal.mult(100)
      |> Decimal.round(2)
      |> Decimal.to_string()

    {:ok, cents}
  end

  defp parse_amount_to_cents(_), do: :error
end
