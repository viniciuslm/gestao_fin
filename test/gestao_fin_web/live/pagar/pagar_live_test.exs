defmodule GestaoFinWeb.Contas.PagarLiveTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory

  test "load page", %{conn: conn} do
    pagar = insert(:pagar)

    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    assert view |> has_element?("[data-role=pagar-item][data-id=#{pagar.id}]")

    assert view
           |> has_element?("[data-role=pagar-titulo][data-id=#{pagar.id}]", pagar.titulo)

    assert has_element?(
             view,
             "[data-role=pagar-valor][data-id=#{pagar.id}]",
             Money.to_string(pagar.valor)
           )
  end

  test "give a conta a pagar that has exist when click to delete then return a message that has deleted the conta a pagar",
       %{conn: conn} do
    pagar = insert(:pagar)

    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    assert view
           |> element("[data-role=del-pagar][data-id=#{pagar.id}]")
           |> render_click()

    assert view |> has_element?("#modal")
    assert view |> has_element?("[data-role=del-item-confirm][data-id=#{pagar.id}]")
    assert view |> has_element?("[data-role=del-item-cancel][data-id=#{pagar.id}]")

    {:ok, view, _html} =
      assert view
             |> element("[data-role=del-item-confirm][data-id=#{pagar.id}]")
             |> render_click()
             |> follow_redirect(conn, Routes.pagar_path(conn, :index))

    refute view |> has_element?("[data-role=del-pagar][data-id=#{pagar.id}]")
  end
end
