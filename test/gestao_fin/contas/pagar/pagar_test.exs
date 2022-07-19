defmodule GestaoFin.Contas.PagarTest do
  use GestaoFin.DataCase
  alias GestaoFin.Contas.Pagar
  alias GestaoFin.ContasPagars
  import GestaoFin.Factory
  import GestaoFin.CategoriaFixtures

  describe "list_contas_pagar/0" do
    test "listar contas a pagar" do
      assert ContasPagars.list_contas_pagar() == []
    end
  end

  describe "create_contas_pagar/1" do
    test "criar uma conta a pagar" do
      categoria = categoria_fixture()
      params = build(:pagar_params, %{"categoria_id" => categoria.id})

      {:ok, contas_pagar} = ContasPagars.create_contas_pagar(params)

      assert "teste conta a pagar" == contas_pagar.titulo
      assert categoria.id == contas_pagar.categoria_id
    end

    test "exibir mensagem de erro ao criar uma conta a pagar" do
      categoria = categoria_fixture()
      params = build(:pagar_params, %{"categoria_id" => categoria.id, "titulo" => ""})

      assert {:error, changeset} = ContasPagars.create_contas_pagar(params)
      assert "can't be blank" in errors_on(changeset).titulo
      assert %{titulo: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "count_contas_pagar/1" do
    test "retorna a quatidade de contas a pagar" do
      assert 0 == ContasPagars.count_contas_pagar(titulo: "")
    end
  end

  describe "get/1" do
    test "buscar uma conta" do
      categoria = categoria_fixture()
      params = build(:pagar_params, %{"categoria_id" => categoria.id})

      {:ok, contas_pagar} = ContasPagars.create_contas_pagar(params)

      contas_pagar_get = ContasPagars.get!(contas_pagar.id)

      assert contas_pagar.titulo == contas_pagar_get.titulo
      assert contas_pagar.descricao == contas_pagar_get.descricao
      assert contas_pagar.paga == contas_pagar_get.paga
    end
  end

  describe "delete_contas_pagar/1" do
    test "deletar uma conta a pagar" do
      categoria = categoria_fixture()
      params = build(:pagar_params, %{"categoria_id" => categoria.id})

      {:ok, contas_pagar} = ContasPagars.create_contas_pagar(params)

      assert {:ok, %Pagar{}} = ContasPagars.delete_contas_pagar(contas_pagar.id)
      assert_raise Ecto.NoResultsError, fn -> ContasPagars.get!(contas_pagar.id) end
    end
  end

  describe "update_contas_pagar/1" do
    test "atualizar uma conta a pagar" do
      categoria = categoria_fixture()
      params = build(:pagar_params, %{"categoria_id" => categoria.id})

      {:ok, contas_pagar} = ContasPagars.create_contas_pagar(params)

      params = build(:pagar_params, %{"categoria_id" => categoria.id, "titulo" => "teste 2"})

      {:ok, contas_pagar_update} = ContasPagars.update_contas_pagar(contas_pagar, params)

      refute contas_pagar.titulo == contas_pagar_update.titulo
      assert contas_pagar.categoria_id == contas_pagar_update.categoria_id
    end
  end

  describe "change_contas_receber/2" do
    test "cria changeset de contas a receber" do
      contas_pagar = ContasPagars.change_contas_pagar(%Pagar{})

      assert %{} == contas_pagar.changes
    end
  end
end
