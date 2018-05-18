defmodule PiezaControlTest do
  use ExUnit.Case
  doctest Ajedrez.PiezaControl

  @mov_invalido {:error, "movimiento invalido"}

  test "movimiento valido peon" do
    pieza = %Pieza{nombre: :peon, p_horizontal: "a", p_vertical: 1}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 2)
  end

  test "movimiento valido peon 2" do
    pieza = %Pieza{nombre: :peon, p_horizontal: "a", p_vertical: 1}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 3)
  end

  test "movimiento valido peon captura" do
    pieza = %Pieza{nombre: :peon, p_horizontal: "a", p_vertical: 1}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "b", 2)
  end

  test "movimiento invalido peon" do
    pieza = %Pieza{nombre: :peon, p_horizontal: "a", p_vertical: 1}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 5) == @mov_invalido
  end

  test "movimiento valido torre" do
    pieza = %Pieza{nombre: :torre, p_horizontal: "a", p_vertical: 1}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 8)
  end

  test "movimiento valido torre 2" do
    pieza = %Pieza{nombre: :torre, p_horizontal: "a", p_vertical: 1}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 1)
  end

  test "movimiento invalido torre" do
    pieza = %Pieza{nombre: :torre, p_horizontal: "a", p_vertical: 1}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "c", 3) == @mov_invalido
  end

  test "movimiento valido alfil" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 1)
  end

  test "movimiento valido alfil 2" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 8)
  end

  test "movimiento valido alfil 3" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 7)
  end

  test "movimiento valido alfil 4" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "g", 1)
  end

  test "movimiento invalido alfil" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "d", 1) == @mov_invalido
  end

  test "movimiento invalido alfil 2" do
    pieza = %Pieza{nombre: :alfil, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 4) == @mov_invalido
  end

  test "movimiento valido caballo" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "b", 3)
  end

  test "movimiento valido caballo 1" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "c", 2)
  end

  test "movimiento valido caballo 3" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "f", 3)
  end

  test "movimiento valido caballo 4" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "e", 6)
  end

  test "movimiento invalido caballo" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "d", 1) == @mov_invalido
  end

  test "movimiento invalido caballo 2" do
    pieza = %Pieza{nombre: :caballo, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 3) == @mov_invalido
  end

  test "movimiento valido dama" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "a", p_vertical: 1}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 8)
  end

  test "movimiento valido dama 2" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "a", p_vertical: 1}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 1)
  end

  test "movimiento valido dama 3" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 1)
  end

  test "movimiento valido dama 4" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 8)
  end

  test "movimiento valido dama 5" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "a", 7)
  end

  test "movimiento valido dama 6" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "g", 1)
  end

  test "movimiento invalido dama" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "b", 1) == @mov_invalido
  end

  test "movimiento invalido dama 2" do
    pieza = %Pieza{nombre: :dama, p_horizontal: "d", p_vertical: 4}
    assert   Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "h", 1) == @mov_invalido
  end

  test "movimiento valido rey" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "c", 3)
  end

  test "movimiento valido rey 2" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "e", 3)
  end

  test "movimiento valido rey 3" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "e", 5)
  end

  test "movimiento valido rey 4" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert  Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "c", 3)
  end

  test "movimiento invalido rey" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "d", 2) == @mov_invalido
  end

  test "movimiento invalido rey 2" do
    pieza = %Pieza{nombre: :rey, p_horizontal: "d", p_vertical: 4}
    assert Ajedrez.PiezaControl.movimiento_pieza_valido(pieza, "d", 6) == @mov_invalido
  end

end
