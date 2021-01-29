defmodule Homework.TransactionsSchemaTest do
  @moduledoc """
  These tests aim to be more integrated to cover the stack
  and test query results from the client expectations
  """
  use Homework.DataCase

  describe "transactions" do
    test "list all transactions" do
      user = insert(:user)
      [transaction | _tail] = insert_list(3, :transaction, amount: 234, user: user)

      %{
        credit: credit,
        debit: debit,
        description: description
      } = transaction

      """
      query {
        transactions {
          #{document_for(:transaction)}
        }
      }
      """
      |> assert_response_matches do
        %{
          "transactions" =>
            [
              %{
                "amount" => "2.34",
                "credit" => ^credit,
                "debit" => ^debit,
                "description" => ^description
              }
              | _tail
            ] = transactions
        }
      end

      assert length(transactions) == 3
    end
  end

  describe "mutations" do
    test "can create a new transaction" do
      merchant = insert(:merchant)
      user = insert(:user)

      mutation = """
        mutation ($userId: ID!, $merchantId: ID!, $companyId: ID!, $description: String!, $amount: Currency, $debit: Boolean!, $credit: Boolean!) {
          createTransaction(userId: $userId, merchantId: $merchantId, debit: $debit, credit: $credit, companyId: $companyId, description: $description, amount: $amount) {
            description
            amount
            debit
            credit
            user {
              id
            }
            merchant {
              id
            }
          }
        }
      """

      args = %{
        "userId" => user.id,
        "merchantId" => merchant.id,
        "companyId" => user.company_id,
        "description" => "Hylian Shield",
        "amount" => "21.12",
        "debit" => true,
        "credit" => false
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "createTransaction" => %{
            "description" => "Hylian Shield",
            "amount" => "21.12",
            "debit" => true,
            "credit" => false
          }
        }
      end
    end

    @tag :pending
    test "can update a transaction" do
      user = insert(:user, company: build(:company))

      transaction =
        insert(:transaction,
          description: "Granny's Potion Shop",
          amount: 222_333,
          user: user,
          company: user.company
        )

      %{id: user_id, company_id: company_id} = user
      %{merchant_id: merchant_id} = transaction

      mutation = """
        mutation ($id:ID!, $amount:Currency!, $description:String!, $debit:Boolean!, $credit:Boolean!, $userId:ID!, $merchantId:ID!, $companyId:ID!) {
          updateTransaction(id: $id, amount: $amount, description: $description, debit: $debit, credit: $credit, userId: $userId, merchantId: $merchantId, companyId: $companyId) {
            description
            amount
            debit
          }
        }
      """

      args = %{
        "id" => transaction.id,
        "amount" => 333_444,
        "description" => "Granny's NEW Potion Shop",
        "debit" => true,
        "credit" => false,
        "userId" => user_id,
        "merchantId" => merchant_id,
        "companyId" => company_id
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "updateTransaction" => %{
            "description" => "Granny's NEW Potion Shop",
            "amount" => "333444.00",
            "debit" => true
          }
        }
      end
    end

    @tag :pending
    test "can delete a transaction" do
      %{id: id} = insert(:transaction)

      """
      mutation($id: ID!) {
        deleteTransaction(id: $id) {
          id
        }
      }
      """
      |> assert_response_matches(variables: %{"id" => id}) do
        %{
          "deleteTransaction" => %{
            "id" => ^id
          }
        }
      end
    end
  end
end
