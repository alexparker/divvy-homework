defmodule Homework.Repo.Migrations.EnableFuzzystrmatch do
  use Ecto.Migration

  def change do
    execute "CREATE extension if not exists fuzzystrmatch;", "DROP extension if exists fuzzystrmatch;"
  end
end
