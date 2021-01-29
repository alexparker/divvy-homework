defmodule Homework.CompaniesSchemaTest do
  @moduledoc """
  These tests aim to be more integrated to cover the stack
  and test query results from the client expectations
  """
  use Homework.DataCase

  describe "company" do
    test "returns a single company" do
      [company | _tail] = insert_list(3, :company, %{credit_line: 10000})

      %{name: name, credit_line: credit} = company

      transaction =
        insert_list(
          3,
          :transaction,
          company: company,
          debit: true,
          credit: false,
          amount: 1000
        )

      """
      query {
         company(id: "#{company.id}") {
          #{document_for(:company)}
        }
      }
      """
      |> assert_response_matches do
        %{
          "company" => %{
            "name" => ^name,
            "creditLine" => ^credit,
            "availableCredit" => 7000
          }
        }
      end
    end
  end
end
