defmodule GestaoFin.Factory do
  use ExMachina.Ecto, repo: GestaoFin.Repo

  alias GestaoFin.Categorias.Categoria
  # alias GestaoFin.Contas.{Pagar, Receber}

  def categoria_params_factory do
    %{
      "nome" => "teste categoria",
      "descricao" => "teste de descricao",
      "ativo" => true
    }
  end

  def categoria_factory do
    %Categoria{
      nome: "teste categoria",
      descricao: "teste de descricao",
      ativo: true,
      id: "ff295d64-4afe-4089-b4ea-e5e8528080ab"
    }
  end

  def receber_params_factory do
    categoria = build(:categoria)

    %{
      "titulo" => "teste conta a receber",
      "descricao" => "descricao conta a receber",
      "valor" => 60210,
      "vencimento" => "2022-07-07",
      "recebida" => true,
      "categoria_id" => categoria.id
    }
  end

  # def receber_factory do
  #   categoria = build(:categoria)

  #   %Receber{
  #     titulo: "teste conta a receber",
  #     descricao: "descricao conta a receber",
  #     valor: 60210,
  #     vencimento: Date.new(2022, 07, 07),
  #     recebida: true,
  #     categoria_id: categoria.id,
  #     id: "ff295d64-4afe-4089-b4ea-e5e8528080ab"
  #   }
  # end

  def pagar_params_factory do
    categoria = build(:categoria)

    %{
      "titulo" => "teste conta a pagar",
      "descricao" => "descricao conta a pagar",
      "valor" => 50_210,
      "vencimento" => "2022-07-07",
      "paga" => true,
      "categoria_id" => categoria.id
    }
  end

  # def pagar_factory do
  #   categoria = build(:categoria)

  #   %Pagar{
  #     titulo: "teste conta a receber",
  #     descricao: "descricao conta a receber",
  #     valor: 60_210,
  #     vencimento: Date.new(2022, 07, 07),
  #     paga: true,
  #     categoria_id: categoria.id,
  #     id: "ff295d64-4afe-4089-b4ea-e5e8528080ab"
  #   }
  # end
end
