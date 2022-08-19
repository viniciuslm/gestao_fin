defmodule GestaoFinWeb.Categorialive.FormTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory
  alias GestaoFin.Categorias

  test "load modal insert categoria", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    open_modal(view)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=categoria-form]")

    assert view |> form("#new", categoria: %{nome: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    open_modal(view)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a categoria when submit the form then return a message that has created the categoria",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    open_modal(view)

    payload = %{
      nome: "teste categoria 2",
      descricao: "teste de categoria",
      ativo: true
    }

    {:ok, _view, html} =
      view
      |> form("#new",
        categoria: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.categoria_path(conn, :index))

    assert html =~ "Categoria criada!"
  end

  test "give a categoria when submit the form then return changeset error",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    open_modal(view)

    payload = %{
      nome: "teste categoria",
      descricao: "teste de categoria",
      ativo: true
    }

    {:ok, _categoria} = Categorias.create_categoria(payload)

    assert view
           |> form("#new",
             categoria: payload
           )
           |> render_submit() =~ "has already been taken"
  end

  test "give a categoria that has already exist when click to edit then open modal and show an error",
       %{conn: conn} do
    categoria = insert(:categoria)
    categoria_2 = insert(:categoria)

    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    assert view
           |> element("[data-role=edit-categoria][data-id=#{categoria.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.categoria_path(conn, :edit, categoria))

    assert view
           |> form("##{categoria.id}", categoria: %{nome: categoria_2.nome})
           |> render_submit() =~
             "has already been taken"
  end

  test "give a categoria that has already exist when click to edit then open modal and execute an action",
       %{conn: conn} do
    categoria = insert(:categoria)

    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    assert view
           |> element("[data-role=edit-categoria][data-id=#{categoria.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.categoria_path(conn, :edit, categoria))

    {:ok, view, html} =
      view
      |> form("##{categoria.id}",
        categoria: %{nome: "teste 2"}
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.categoria_path(conn, :index))

    assert html =~ "Categoria atualizada!"
    assert view |> has_element?("[data-role=categoria-item][data-id=#{categoria.id}]")
    assert view |> has_element?("[data-role=categoria-nome][data-id=#{categoria.id}]", "teste 2")
  end

  defp open_modal(view) do
    view
    |> element("[data-role=add-categoria]")
    |> render_click()
  end
end
