defmodule JugadorControlTest do
  use ExUnit.Case
  doctest Ajedrez.JugadorControl



  test "agrega piezas jugador" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    rey = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 1}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [rey])
    assert length(jugador.piezas) == 1
  end

  test "elimina piezas jugador" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    rey = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 1}
    peon = %Pieza{nombre: :peon, jugador: jugador, p_horizontal: "e", p_vertical: 2}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [rey, peon])
    jugador = Ajedrez.JugadorControl.jugador_elimina_pieza(jugador, peon)
    assert length(jugador.piezas) == 1
  end


  test "get rey piezas jugador" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    rey = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 1}
    peon = %Pieza{nombre: :peon, jugador: jugador, p_horizontal: "e", p_vertical: 2}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [rey, peon])
    rey_2 = Ajedrez.JugadorControl.get_rey(jugador)
    assert rey == rey_2
  end


  test "get rey piezas jugador nil" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    peon1 = %Pieza{nombre: :peon, jugador: jugador, p_horizontal: "e", p_vertical: 2}
    peon2 = %Pieza{nombre: :peon, jugador: jugador, p_horizontal: "e", p_vertical: 3}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [peon1, peon2])
    rey = Ajedrez.JugadorControl.get_rey(jugador)
    assert nil == rey
  end

  test "actualiza piezas jugador" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    rey_1 = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 1}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [rey_1])
    rey_2 = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 8}
    jugador = Ajedrez.JugadorControl.jugador_actualiza_pieza(jugador, rey_2, rey_1)
    rey =  Ajedrez.JugadorControl.get_rey(jugador)
    assert rey == rey_2
  end

  test "actualiza piezas jugador error" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    rey_1 = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 1}
    peon1 = %Pieza{nombre: :peon, jugador: jugador, p_horizontal: "e", p_vertical: 2}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza(jugador, [rey_1])
    rey_2 = %Pieza{nombre: :rey, jugador: jugador, p_horizontal: "e", p_vertical: 8}
    {:error, causa} = Ajedrez.JugadorControl.jugador_actualiza_pieza(jugador, rey_2, peon1)
    assert causa == "no se encontro pieza"
  end

  test " jugador agrega piezas short" do
    jugador = %Jugador{nombre: "jugador 1", color: :blancas}
    jugador = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador, [["p", "a", 1], ["r", "a", 2]])
    assert Ajedrez.JugadorControl.get_rey(jugador).p_horizontal == "a"
  end

end
