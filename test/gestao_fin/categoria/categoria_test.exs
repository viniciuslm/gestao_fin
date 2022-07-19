defmodule GestaoFin.Contas.CategoriaTest do
  use GestaoFin.DataCase
  alias GestaoFin.Categorias
  alias GestaoFin.Categorias.Categoria
  import GestaoFin.Factory

  describe "list_categoria/0" do
    test "listar categoria" do
      assert Categorias.list_categorias() == []
    end
  end

  describe "list_categoria_ativas/0" do
    test "listar categorias ativas" do
      assert Categorias.list_categorias_ativas() == []
    end
  end

  describe "create_categoria/1" do
    test "criar uma categoria" do
      params = build(:categoria_params)

      {:ok, categoria} = Categorias.create_categoria(params)

      assert "teste categoria" == categoria.nome
    end

    test "exibir mensagem de erro ao criar uma categoria" do
      params = build(:categoria_params, %{"nome" => ""})

      assert {:error, changeset} = Categorias.create_categoria(params)
      assert "can't be blank" in errors_on(changeset).nome
      assert %{nome: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "count_categoria/1" do
    test "retorna a quatidade de categoria" do
      assert 0 == Categorias.count_categorias(nome: "teste")
    end
  end

  describe "get/1" do
    test "buscar uma conta" do
      params = build(:categoria_params)

      {:ok, categoria} = Categorias.create_categoria(params)

      categoria_get = Categorias.get!(categoria.id)

      assert categoria.nome == categoria_get.nome
      assert categoria.descricao == categoria_get.descricao
      assert categoria.ativo == categoria_get.ativo
    end
  end

  describe "delete_categoria/1" do
    test "deletar uma conta a categoria" do
      params = build(:categoria_params)

      {:ok, categoria} = Categorias.create_categoria(params)

      assert {:ok, %Categoria{}} = Categorias.delete_categoria(categoria.id)
      assert_raise Ecto.NoResultsError, fn -> Categorias.get!(categoria.id) end
    end
  end

  describe "update_categoria/1" do
    test "atualizar uma conta a categoria" do
      params = build(:categoria_params)

      {:ok, categoria} = Categorias.create_categoria(params)

      params = build(:categoria_params, %{"nome" => "teste 2"})

      {:ok, categoria_update} = Categorias.update_categoria(categoria, params)

      refute categoria.nome == categoria_update.nome
      assert categoria.descricao == categoria_update.descricao
    end
  end
end
