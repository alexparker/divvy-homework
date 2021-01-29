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

      _transactions =
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

  describe "companies" do
    test "list all companies" do
      [%{name: name, credit_line: credit_line} = company | _tail] = insert_list(3, :company)
      insert(:transaction, amount: 300, debit: true, credit: false, company: company)
      available_credit = credit_line - 300

      """
      query {
        companies {
          #{document_for(:company)}
        }
      }
      """
      |> assert_response_matches do
        %{
          "companies" =>
            [
              %{
                "name" => ^name,
                "creditLine" => ^credit_line,
                "availableCredit" => ^available_credit
              }
              | _tail
            ] = companies
        }
      end

      assert length(companies) == 3
    end
  end

  describe "mutations" do
    test "can create a new company" do
      mutation = """
        mutation ($name: String!) {
          createCompany(name: $name, creditLine: 22233300) {
            name
            creditLine
            availableCredit
          }
        }
      """

      args = %{
        "name" => "Lord Jabu Jabu",
        "creditLine" => 22_233_300
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "createCompany" => %{
            "name" => "Lord Jabu Jabu",
            "creditLine" => 22_233_300
          }
        }
      end
    end

    test "can update a company" do
      company = insert(:company, name: "Granny's Potion Shop", credit_line: 222_333)

      mutation = """
        mutation ($id: ID!, $name: String!, $creditLine: Int!) {
          updateCompany(id: $id, name: $name, creditLine: $creditLine) {
            name
            creditLine
            availableCredit
          }
        }
      """

      args = %{
        "id" => company.id,
        "name" => "Granny's NEW Potion Shop",
        "creditLine" => 333_444
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "updateCompany" => %{
            "name" => "Granny's NEW Potion Shop",
            "creditLine" => 333_444
          }
        }
      end
    end

    test "can delete a company" do
      %{id: id} = insert(:company)

      """
      mutation($id: ID!) {
        deleteCompany(id: $id) {
          id
        }
      }
      """
      |> assert_response_matches(variables: %{"id" => id}) do
        %{
          "deleteCompany" => %{
            "id" => ^id
          }
        }
      end
    end
  end
end
