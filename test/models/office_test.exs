defmodule Main.OfficeTest do
  use Main.ModelCase

  alias Main.Office

  @valid_attrs %{height: 42, title: "some content", width: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Office.changeset(%Office{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Office.changeset(%Office{}, @invalid_attrs)
    refute changeset.valid?
  end
end
