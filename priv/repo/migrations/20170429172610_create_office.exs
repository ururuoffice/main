defmodule Main.Repo.Migrations.CreateOffice do
  use Ecto.Migration

  def change do
    create table(:offices) do
      add :title, :string
      add :width, :integer
      add :height, :integer

      timestamps()
    end
    create unique_index(:offices, [:title])

  end
end
