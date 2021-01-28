defmodule Homework.Factory do
  use ExMachina.Ecto, repo: Homework.Repo

  def user_factory do
    %Homework.Users.User{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      dob: "#{Faker.Date.date_of_birth(18..98)}"
    }
  end
end
