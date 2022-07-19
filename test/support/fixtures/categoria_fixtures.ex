defmodule GestaoFin.CategoriaFixtures do
  alias GestaoFin.Categorias

  def categoria_fixture(attrs \\ %{}) do
    {:ok, categoria} =
      attrs
      |> Enum.into(%{
        nome: "teste categoria",
        descricao: "descricao categoria",
        ativo: true
      })
      |> Categorias.create_categoria()

    categoria
  end
end
