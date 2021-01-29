defmodule Homework.CompaniesTest do
  use Homework.DataCase

  alias Homework.Companies

  describe "companies" do
    alias Homework.Companies.Company

    @valid_attrs %{credit_line: 42, name: "some name"}
    @update_attrs %{credit_line: 43, name: "some updated name"}
    @invalid_attrs %{credit_line: nil, name: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end
  end
end
