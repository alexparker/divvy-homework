# Homework

You will need to have postgres running.
The easiest way to install postgres is through brew:
`brew install postgres`

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:8000`](http://localhost:8000) from your browser.
You can use [`localhost:8000/graphiql`](http://localhost:8000/graphiql) to make basic graphql queries from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Homework Report

Small disclaimer: Having not used Absinthe, or graphql, there was a minor learning curve to get 
acquainted with things. But overall was enjoyable and a fun coding assignment.

I imagine there are a lot of improvements, clean coding abstractions I'd like to develop after using and testing
absinth and graphql environment more. 

This was a fun exercise. I look forward to answering any questions about my choices
and hearing feedback on what aligned with Divvy's internal practices or where I could 
have approached it more optimally.

## **Objectives**

- [x]  Write filtering options for transactions, users, and/or merchants. This could include:
    - [x]  fuzzy searching for a user by first and last name
    - [ ]  fuzzy searching for a merchant by name
    - [ ]  getting back transactions with an amount between `min` and `max` arguments
- [x]  Write a new schema, queries, and mutations to add companies to the app
    - [x]  users should belong to a company and we should require transactions to pass in a `company_id`
    - [x]  company should have a `name`, `credit_line`, and `available_credit` which would be the `credit_line` minus the total amount of `transactions` for the company
- [x]  Seed the database. Possible solutions include:
    - [x]  Implement provided `seeds.ex` file _only partially for experimenting with graphiql_
    - [ ]  Write a `.sql` file that can be ingested by the database
- [x]  Write tests for the resolvers & mutations.
    - [x]  Testing that you can get information from the resolver queries
    - [x]  Testing that you can get create/update/delete from the resolver mutations
- [ ]  Add a pagination layer to the queries
    - [ ] Should include a `limit` (how many rows to return) and `skip` (how many rows to skip) options
    - [ ] Should return a `total_rows` (how many total rows exist)
    - [ ] Bonus: Make it a wrapper that all the schemas can tap into.
- [x]  Allow the mutations to handle a decimal amount for transactions (the database stores it as cents)
    - [x]  Mutations need to convert the Decimal amount to an Integer e.g. 24.68 becomes 2468
    - [x]  The queries should convert the Integer amount to a Decimal e.g. 2468 becomes 24.68
