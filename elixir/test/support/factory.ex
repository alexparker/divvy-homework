defmodule Homework.Factory do
  use ExMachina.Ecto, repo: Homework.Repo

  @doc """
  User Factory
  """
  def user_factory do
    %Homework.Users.User{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      dob: "#{Faker.Date.date_of_birth(18..98)}",
      company: build(:company)
    }
  end

  @doc """
  Company Factory
  """
  def company_factory do
    %Homework.Companies.Company{
      name: Faker.Team.name(),
      credit_line: Enum.random(100..1000)
    }
  end

  @doc """
  Merchant Factory
  """
  def merchant_factory do
    %Homework.Merchants.Merchant{
      name: Faker.Lorem.sentence(2..3),
      description: Faker.Lorem.sentence()
    }
  end

  @doc """
  Transaction Factory
  """
  def transaction_factory do
    is_credit = Enum.random([true, false])

    %Homework.Transactions.Transaction{
      amount: Enum.random(1..1000),
      credit: is_credit,
      debit: !is_credit,
      description: Faker.Lorem.sentence(),
      merchant: build(:merchant)
    }
  end
end
