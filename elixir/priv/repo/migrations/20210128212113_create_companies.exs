defmodule Homework.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :credit_line, :integer

      timestamps()
    end

    alter table(:users) do
      add :company_id, references(:companies, on_delete: :delete_all, type: :uuid)
    end

    alter table(:transactions) do
      add :company_id, references(:companies, on_delete: :delete_all, type: :uuid)
    end
  end
end
