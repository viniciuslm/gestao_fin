defmodule GestaoFin.Contas.ReceberTest do
  use GestaoFin.DataCase
  alias GestaoFin.Contas.Receber
  alias GestaoFin.ContasRecebers
  import GestaoFin.Factory
  import GestaoFin.CategoriaFixtures

  describe "list_contas_receber/0" do
    test "listar contas a receber" do
      assert ContasRecebers.list_contas_receber() == []
    end
  end

  describe "create_contas_receber/1" do
    test "criar uma conta a receber" do
      categoria = categoria_fixture()
      params = build(:receber_params, %{"categoria_id" => categoria.id})

      {:ok, contas_receber} = ContasRecebers.create_contas_receber(params)

      assert "teste conta a receber" == contas_receber.titulo
      assert categoria.id == contas_receber.categoria_id
    end

    test "exibir mensagem de erro ao criar uma conta a receber" do
      categoria = categoria_fixture()
      params = build(:receber_params, %{"categoria_id" => categoria.id, "titulo" => ""})

      assert {:error, changeset} = ContasRecebers.create_contas_receber(params)
      assert "can't be blank" in errors_on(changeset).titulo
      assert %{titulo: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "count_contas_receber/1" do
    test "retorna a quatidade de contas a receber" do
      assert 0 == ContasRecebers.count_contas_receber(titulo: "")
    end
  end

  describe "get/1" do
    test "buscar uma conta" do
      categoria = categoria_fixture()
      params = build(:receber_params, %{"categoria_id" => categoria.id})

      {:ok, contas_receber} = ContasRecebers.create_contas_receber(params)

      contas_receber_get = ContasRecebers.get!(contas_receber.id)

      assert contas_receber.titulo == contas_receber_get.titulo
      assert contas_receber.descricao == contas_receber_get.descricao
      assert contas_receber.recebida == contas_receber_get.recebida
    end
  end

  describe "delete_contas_receber/1" do
    test "deletar uma conta a receber" do
      categoria = categoria_fixture()
      params = build(:receber_params, %{"categoria_id" => categoria.id})

      {:ok, contas_receber} = ContasRecebers.create_contas_receber(params)

      assert {:ok, %Receber{}} = ContasRecebers.delete_contas_receber(contas_receber.id)
      assert_raise Ecto.NoResultsError, fn -> ContasRecebers.get!(contas_receber.id) end
    end
  end

  describe "update_contas_receber/1" do
    test "atualizar uma conta a receber" do
      categoria = categoria_fixture()
      params = build(:receber_params, %{"categoria_id" => categoria.id})

      {:ok, contas_receber} = ContasRecebers.create_contas_receber(params)

      params = build(:receber_params, %{"categoria_id" => categoria.id, "titulo" => "teste 2"})

      {:ok, contas_receber_update} = ContasRecebers.update_contas_receber(contas_receber, params)

      refute contas_receber.titulo == contas_receber_update.titulo
      assert contas_receber.categoria_id == contas_receber_update.categoria_id
    end
  end

  describe "change_contas_receber/2" do
    test "cria changeset de contas a receber" do
      contas_receber = ContasRecebers.change_contas_receber(%Receber{})

      assert %{} == contas_receber.changes
    end
  end
end
