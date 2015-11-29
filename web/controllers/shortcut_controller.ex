defmodule PhoenixUrlShortener.ShortcutController do
  use PhoenixUrlShortener.Web, :controller

  alias PhoenixUrlShortener.Shortcut

  plug :scrub_params, "shortcut" when action in [:create, :update]

  def index(conn, _params) do
    shortcuts = Repo.all(Shortcut)
    render(conn, "index.json", shortcuts: shortcuts)
  end

  def create(conn, %{"shortcut" => shortcut_params}) do
    changeset = Shortcut.changeset(%Shortcut{}, shortcut_params)

    case Repo.insert(changeset) do
      {:ok, shortcut} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", shortcut_path(conn, :show, shortcut))
        |> render("show.json", shortcut: shortcut)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixUrlShortener.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    shortcut = Repo.get!(Shortcut, id)
    render(conn, "show.json", shortcut: shortcut)
  end

  def update(conn, %{"id" => id, "shortcut" => shortcut_params}) do
    shortcut = Repo.get!(Shortcut, id)
    changeset = Shortcut.changeset(shortcut, shortcut_params)

    case Repo.update(changeset) do
      {:ok, shortcut} ->
        render(conn, "show.json", shortcut: shortcut)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixUrlShortener.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shortcut = Repo.get!(Shortcut, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shortcut)

    send_resp(conn, :no_content, "")
  end
end
