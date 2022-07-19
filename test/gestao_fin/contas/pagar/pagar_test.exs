defmodule GestaoFin.Contas.PagarTest do
  use GestaoFin.DataCase
  alias GestaoFin.Contas

  describe "list_contas_pagar/0" do
    test "listar contas a pagar" do
      assert Contas.list_contas_pagar() == []
    end
  end
end
