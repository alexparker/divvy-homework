defmodule HomeworkWeb.UsersResolverTest do
  @moduledoc """
    Note for Divvy:
    The objective states to test the resolvers.
    I've covered some tests here, but it seems thin
    because the amount of work the resolvers do is pretty minimal
    Most of it is delegated to the contexts.
  """
  use Homework.DataCase

  alias HomeworkWeb.Resolvers.UsersResolver

  setup do
    users = insert_list(4, :user)

    {:ok, %{users: users}}
  end

  describe "create_user/3" do
    test "creates a user with valid inputs" do
      args = %{
        first_name: "Darunia",
        last_name: "Goron",
        dob: "Cool Birthday"
      }

      {:ok, user} = UsersResolver.create_user(nil, args, nil)
      assert user.first_name == args.first_name
    end
  end

  describe "users/3" do
    test "returns a list of all users", %{users: users} do
      {:ok, result} = UsersResolver.users(%{}, [], [])

      assert length(result) == 4
      assert_lists_equal(result, users, &(&1.id == &2.id))
    end
  end

  describe "update_user/3" do
    test "updates a user with new attributes", %{users: [user | _tail]} do
      args = %{
        id: user.id,
        first_name: "Darunia",
        last_name: "Goron",
        dob: "Cool Birthday"
      }

      refute user.first_name == args.first_name
      refute user.last_name == args.last_name
      refute user.dob == args.dob

      {:ok, updated_user} = UsersResolver.update_user(nil, args, nil)
      assert user.id == updated_user.id
      assert updated_user.first_name == args.first_name
      assert updated_user.last_name == args.last_name
      assert updated_user.dob == args.dob
    end
  end

  describe "delete_user/3" do
    test "deletes a user by id", %{users: [user | tail]} do
      {:ok, _deleted_user} = UsersResolver.delete_user(nil, %{id: user.id}, nil)
      assert_lists_equal(tail, Homework.Users.list_users([]), &(&1.id == &2.id))
    end
  end

  describe "get_company/3" do
    test "gets comapny of a user by id", %{users: [user | _tail]} do
      {:ok, %Homework.Companies.Company{} = company} = UsersResolver.get_company(user, %{}, nil)
      assert company.id == user.company_id
    end
  end
end
