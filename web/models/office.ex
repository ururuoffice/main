defmodule Main.Office do
  use Main.Web, :model

  schema "offices" do
    field :title, :string
    field :width, :integer
    field :height, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :width, :height])
    |> validate_required([:title, :width, :height])
    |> unique_constraint(:title)
  end
end
