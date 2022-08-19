defmodule GestaoFinWeb.CategorialiveTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory

  test "load page", %{conn: conn} do
    categoria = insert(:categoria)

    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    assert view |> has_element?("[data-role=categoria-item][data-id=#{categoria.id}]")

    assert view
           |> has_element?(
             "[data-role=categoria-nome][data-id=#{categoria.id}]",
             categoria.nome
           )
  end

  test "give a categoria that has exist when click to delete then return a message that has deleted the categoria",
       %{conn: conn} do
    categoria = insert(:categoria)

    {:ok, view, _html} = live(conn, Routes.categoria_path(conn, :index))

    assert view
           |> element("[data-role=del-categoria][data-id=#{categoria.id}]")
           |> render_click()

    assert view |> has_element?("#modal")
    assert view |> has_element?("[data-role=del-item-confirm][data-id=#{categoria.id}]")
    assert view |> has_element?("[data-role=del-item-cancel][data-id=#{categoria.id}]")

    {:ok, view, _html} =
      assert view
             |> element("[data-role=del-item-confirm][data-id=#{categoria.id}]")
             |> render_click()
             |> follow_redirect(conn, Routes.categoria_path(conn, :index))

    refute view |> has_element?("[data-role=del-categoria][data-id=#{categoria.id}]")
  end
end
