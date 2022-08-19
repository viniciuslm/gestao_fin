defmodule GestaoFinWeb.Contas.PagarLive.FormTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory

  test "load modal insert conta a pagar", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    open_modal(view)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=pagar-form]")

    assert view |> form("#new", pagar: %{titulo: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    open_modal(view)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a conta a pagar when submit the form then return a message that has created the conta a pagar",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))
    categoria = insert(:categoria)

    open_modal(view)

    payload = %{
      titulo: "teste conta a pagar",
      descricao: "descricao conta a pagar",
      valor: 50_210,
      vencimento: "2022-07-07",
      paga: true,
      categoria_id: categoria.id
    }

    {:ok, _view, html} =
      view
      |> form("#new",
        pagar: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.pagar_path(conn, :index))

    assert html =~ "Conta a pagar criada!"
  end

  test "give a conta a pagar when submit the form then return changeset error",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))
    categoria = insert(:categoria)

    open_modal(view)

    payload = %{
      titulo: "teste conta a pagar",
      descricao: "descricao conta a pagar",
      valor: 210,
      categoria_id: categoria.id
    }

    assert view
           |> form("#new",
             pagar: payload
           )
           |> render_submit() =~
             "can&#39;t be blank"
  end

  test "give a conta a pagar that has already exist when click to edit then open modal and show an error",
       %{conn: conn} do
    pagar = insert(:pagar)

    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    assert view
           |> element("[data-role=edit-pagar][data-id=#{pagar.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.pagar_path(conn, :edit, pagar))

    assert view
           |> form("##{pagar.id}", pagar: %{titulo: nil})
           |> render_submit() =~
             "can&#39;t be blank"
  end

  test "give a conta a pagar that has already exist when click to edit then open modal and execute an action",
       %{conn: conn} do
    pagar = insert(:pagar)

    {:ok, view, _html} = live(conn, Routes.pagar_path(conn, :index))

    assert view
           |> element("[data-role=edit-pagar][data-id=#{pagar.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.pagar_path(conn, :edit, pagar))

    {:ok, view, html} =
      view
      |> form("##{pagar.id}",
        pagar: %{titulo: "teste 2"}
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.pagar_path(conn, :index))

    assert html =~ "Conta a pagar atualizada!"
    assert view |> has_element?("[data-role=pagar-item][data-id=#{pagar.id}]")
    assert view |> has_element?("[data-role=pagar-titulo][data-id=#{pagar.id}]", "teste 2")
  end

  defp open_modal(view) do
    view
    |> element("[data-role=add-pagar]")
    |> render_click()
  end
end
