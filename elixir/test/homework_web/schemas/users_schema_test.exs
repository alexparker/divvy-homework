defmodule Homework.UsersSchemaTest do
  @moduledoc """
  These tests aim to be more integrated to cover the stack
  and test query results from the client expectations
  """
  use Homework.DataCase

  describe "users" do
    test "lists users" do
      factory_users = insert_list(3, :user)

      """
      query {
        users {
          #{document_for(:user)}
        }
      }
      """
      |> assert_response_matches do
        %{
          "users" =>
            [
              %{
                "dob" => _dob,
                "firstName" => _first,
                "lastName" => _last,
                "company" => %{
                  "name" => _name,
                  "creditLine" => _credit_line,
                  "availableCredit" => _available_credit
                }
              }
              | _tail
            ] = response_users
        }
      end

      assert_lists_equal(factory_users, response_users, &(&1.id == &2["id"]))

      assert length(response_users) == 3
    end
  end

  describe "mutations" do
    test "can create a new user" do
      mutation = """
        mutation ($dob: String!, $firstName: String!, $lastName: String!) {
          createUser(dob: $dob, firstName: $firstName, lastName: $lastName) {
            firstName
            lastName
            dob
          }
        }
      """

      args = %{
        "dob" => "dob dob",
        "firstName" => "Sam",
        "lastName" => "Wise"
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "createUser" => %{
            "dob" => "dob dob",
            "firstName" => "Sam",
            "lastName" => "Wise"
          }
        }
      end
    end

    test "can update a users" do
      user = insert(:user, first_name: "not frodo", last_name: "not baggins", dob: "nodob")

      mutation = """
        mutation ($id: ID!, $dob: String!, $firstName: String!, $lastName: String!) {
          updateUser(id: $id, dob: $dob, firstName: $firstName, lastName: $lastName) {
            firstName
            lastName
            dob
          }
        }
      """

      args = %{
        "id" => user.id,
        "dob" => "new dob",
        "firstName" => "Frodo",
        "lastName" => "Baggins"
      }

      assert_response_matches(mutation, variables: args) do
        %{
          "updateUser" => %{
            "dob" => "new dob",
            "firstName" => "Frodo",
            "lastName" => "Baggins"
          }
        }
      end
    end

    test "can delete a user" do
      %{id: id} = insert(:user)

      """
      mutation($id: ID!) {
        deleteUser(id: $id) {
          id
        }
      }
      """
      |> assert_response_matches(variables: %{"id" => id}) do
        %{
          "deleteUser" => %{
            "id" => ^id
          }
        }
      end
    end
  end
end
