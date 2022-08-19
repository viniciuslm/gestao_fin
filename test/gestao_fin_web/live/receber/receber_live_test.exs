defmodule GestaoFinWeb.Contas.ReceberLiveTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory

  test "load page", %{conn: conn} do
    receber = insert(:receber)

    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    assert view |> has_element?("[data-role=receber-item][data-id=#{receber.id}]")

    assert view
           |> has_element?("[data-role=receber-titulo][data-id=#{receber.id}]", receber.titulo)

    assert has_element?(
             view,
             "[data-role=receber-valor][data-id=#{receber.id}]",
             Money.to_string(receber.valor)
           )
  end

  test "give a conta a receber that has exist when click to delete then return a message that has deleted the conta a receber",
       %{conn: conn} do
    receber = insert(:receber)

    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    assert view
           |> element("[data-role=del-receber][data-id=#{receber.id}]")
           |> render_click()

    assert view |> has_element?("#modal")
    assert view |> has_element?("[data-role=del-item-confirm][data-id=#{receber.id}]")
    assert view |> has_element?("[data-role=del-item-cancel][data-id=#{receber.id}]")

    {:ok, view, _html} =
      assert view
             |> element("[data-role=del-item-confirm][data-id=#{receber.id}]")
             |> render_click()
             |> follow_redirect(conn, Routes.receber_path(conn, :index))

    refute view |> has_element?("[data-role=del-receber][data-id=#{receber.id}]")
  end
end
