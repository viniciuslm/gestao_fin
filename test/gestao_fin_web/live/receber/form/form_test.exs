defmodule GestaoFinWeb.Contas.ReceberLive.FormTest do
  use GestaoFinWeb.ConnCase
  import Phoenix.LiveViewTest
  import GestaoFin.Factory

  test "load modal insert conta a receber", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    open_modal(view)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=receber-form]")

    assert view |> form("#new", receber: %{titulo: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    open_modal(view)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a conta a receber when submit the form then return a message that has created the conta a receber",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))
    categoria = insert(:categoria)

    open_modal(view)

    payload = %{
      titulo: "teste conta a receber",
      descricao: "descricao conta a receber",
      valor: 50_210,
      vencimento: "2022-07-07",
      recebida: true,
      categoria_id: categoria.id
    }

    {:ok, _view, html} =
      view
      |> form("#new",
        receber: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.receber_path(conn, :index))

    assert html =~ "Conta a receber criada!"
  end

  test "give a conta a receber when submit the form then return changeset error",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))
    categoria = insert(:categoria)

    open_modal(view)

    payload = %{
      titulo: "teste conta a receber",
      descricao: "descricao conta a receber",
      valor: 210,
      categoria_id: categoria.id
    }

    assert view
           |> form("#new",
             receber: payload
           )
           |> render_submit() =~
             "can&#39;t be blank"
  end

  test "give a conta a receber that has already exist when click to edit then open modal and show an error",
       %{conn: conn} do
    receber = insert(:receber)

    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    assert view
           |> element("[data-role=edit-receber][data-id=#{receber.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.receber_path(conn, :edit, receber))

    assert view
           |> form("##{receber.id}", receber: %{titulo: nil})
           |> render_submit() =~
             "can&#39;t be blank"
  end

  test "give a conta a receber that has already exist when click to edit then open modal and execute an action",
       %{conn: conn} do
    receber = insert(:receber)

    {:ok, view, _html} = live(conn, Routes.receber_path(conn, :index))

    assert view
           |> element("[data-role=edit-receber][data-id=#{receber.id}]")
           |> render_click()

    assert view |> has_element?("#modal")

    assert_patch(view, Routes.receber_path(conn, :edit, receber))

    {:ok, view, html} =
      view
      |> form("##{receber.id}",
        receber: %{titulo: "teste 2"}
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.receber_path(conn, :index))

    assert html =~ "Conta a receber atualizada!"
    assert view |> has_element?("[data-role=receber-item][data-id=#{receber.id}]")
    assert view |> has_element?("[data-role=receber-titulo][data-id=#{receber.id}]", "teste 2")
  end

  defp open_modal(view) do
    view
    |> element("[data-role=add-receber]")
    |> render_click()
  end
end
