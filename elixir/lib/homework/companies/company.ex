defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homework.Transactions.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field(:credit_line, :integer)
    field(:name, :string)

    has_many(:transactions, Transaction, foreign_key: :company_id)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line])
    |> validate_required([:name, :credit_line])
  end
end
