defmodule PhoenixUrlShortener.Shortcut do
  use PhoenixUrlShortener.Web, :model

  schema "shortcuts" do
    field :slug, :string
    field :target_url, :string

    timestamps
  end

  @required_fields ~w(target_url)
  @optional_fields ~w(slug)
  @slug_chars Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_uri(:target_url)
    |> fill_in_missing_slug()
  end

  def validate_uri(changeset, field) do
    validate_change(changeset, field, &uri_validator/2)
  end

  def uri_validator(field, uri_string) do
    uri = URI.parse(uri_string)
    if uri.scheme in ~w(http https) && uri.host do
      []
    else
      [{field, "must be an http or https URL"}]
    end
  end

  def fill_in_missing_slug(%{changes: %{slug: _}} = changeset) do
    changeset
  end

  def fill_in_missing_slug(changeset) do
    changeset
    |> put_change(:slug, Enum.take_random(@slug_chars, 8))
  end
end
