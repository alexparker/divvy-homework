# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#
Enum.map(0..50, fn i ->
  Homework.Repo.insert!(%Homework.Users.User{
    first_name: Faker.Person.first_name(),
    last_name: Faker.Person.last_name(),
    dob: "#{Faker.Date.date_of_birth(18..98)}"
  });
end)
