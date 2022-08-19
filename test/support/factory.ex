defmodule GestaoFin.Factory do
  use ExMachina.Ecto, repo: GestaoFin.Repo
  alias GestaoFin.Categorias.Categoria
  alias GestaoFin.Contas.{Pagar, Receber}

  @boolean [true, false]
  def categoria_params_factory do
    %{
      "nome" => "teste categoria",
      "descricao" => "teste de descricao",
      "ativo" => true
    }
  end

  def categoria_factory do
    %Categoria{
      nome: Faker.Commerce.department(),
      descricao: Faker.Food.description(),
      ativo: true
    }
  end

  def receber_params_factory do
    categoria = insert(:categoria)

    %{
      "titulo" => "teste conta a receber",
      "descricao" => "descricao conta a receber",
      "valor" => 60_210,
      "vencimento" => "2022-07-07",
      "recebida" => true,
      "categoria_id" => categoria.id
    }
  end

  def receber_factory do
    categoria = insert(:categoria)

    %Receber{
      titulo:
        Faker.Commerce.department() <>
          " a receber " <> (:rand.uniform(100) |> Integer.to_string()),
      descricao: Faker.Food.description(),
      valor: :rand.uniform(1_000),
      vencimento: Faker.Date.date_of_birth(),
      recebida: @boolean |> Enum.shuffle() |> hd,
      categoria_id: categoria.id
    }
  end

  def pagar_params_factory do
    categoria = insert(:categoria)

    %{
      "titulo" => "teste conta a pagar",
      "descricao" => "descricao conta a pagar",
      "valor" => 50_210,
      "vencimento" => "2022-07-07",
      "paga" => true,
      "categoria_id" => categoria.id
    }
  end

  def pagar_factory do
    categoria = insert(:categoria)

    %Pagar{
      titulo:
        Faker.Commerce.department() <> " a pagar " <> (:rand.uniform(100) |> Integer.to_string()),
      descricao: Faker.Food.description(),
      valor: :rand.uniform(1_000),
      vencimento: Faker.Date.date_of_birth(),
      paga: @boolean |> Enum.shuffle() |> hd,
      categoria_id: categoria.id
    }
  end
end
