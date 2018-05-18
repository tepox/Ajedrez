defmodule TableroControlTest do
  use ExUnit.Case
  doctest TableroControl

setup_all do
 {:ok, jugadores: {%Jugador{nombre: "jugador 1", color: :blancas},
    %Jugador{nombre: "jugador 2", color: :negras}}}
end

require Logger
  test "inicia juego" , %{jugadores: {jugador1, jugador2}}  do
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    assert Map.get(Map.get(tablero, :a), 1).nombre == :torre
    assert Map.get(Map.get(tablero, :b), 8).nombre == :caballo
    assert Map.get(Map.get(tablero, :c), 1).nombre == :alfil
    assert Map.get(Map.get(tablero, :d), 8).nombre == :dama
    assert Map.get(Map.get(tablero, :e), 1).nombre == :rey
    assert Map.get(Map.get(tablero, :f), 8).nombre == :alfil
    assert Map.get(Map.get(tablero, :g), 8).nombre == :caballo
    assert Map.get(Map.get(tablero, :h), 8).nombre == :torre
    assert Ajedrez.JugadorControl.get_rey(jugador1) == Map.get(Map.get(tablero, :e), 1)
    assert Ajedrez.JugadorControl.get_rey(jugador2) == Map.get(Map.get(tablero, :e), 8)
  end

  test "pieza tablero" do
    {tablero, _, _} = TableroControl.inicia_juego(%Tablero{}, %Jugador{}, %Jugador{})
    assert TableroControl.pieza_tablero(tablero, "a", 2).nombre == :peon
    assert TableroControl.pieza_tablero(tablero, "a", 7).nombre == :peon
    assert TableroControl.pieza_tablero(tablero, "a", 5) == nil
  end

  test "movimiento valido peon 1", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["p", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "e", 3)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido peon 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["p", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "e", 4)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "captura valida peon ", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["p", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8], ["a", "d", 3]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "d", 3)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento invalido peon ", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["p", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8], ["a", "d", 3]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "h", 3)
    |> TableroControl.moviento(tablero)
    assert error == {:error, "movimiento invalido"}
  end

  test "movimiento valido torre", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "e", 6)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido torre 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "a", 2)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento invalido torre", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "c", 4)
    |> TableroControl.moviento(tablero)
    assert error == {:error, "movimiento invalido"}
  end

  test "movimiento valido alfil", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["a", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "c", 4)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido alfil 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["a", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "h", 5)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento invalido alfil", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["a", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "a", 2)
    |> TableroControl.moviento(tablero)
    assert error == {:error, "movimiento invalido"}
  end

  test "movimiento valido caballo", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["c", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "d", 4)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido caballo 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["c", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "c", 1)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento invalido caballo", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["c", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "e", 4)
    |> TableroControl.moviento(tablero)
    assert error == {:error, "movimiento invalido"}
  end

  test "movimiento valido dama 1", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "e", 6)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido dama 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "c", 4)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento valido dama 3", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "h", 2)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 2) == nil
  end

  test "movimiento invalido dama", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
    tablero
    |> TableroControl.pieza_tablero("e", 2)
    |> Help.get_movimiento(jugador1, jugador2, "h", 6)
    |> TableroControl.moviento(tablero)
    assert error == {:error, "movimiento invalido"}
  end

  test "movimiento valido rey 1", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 1)
    |> Help.get_movimiento(jugador1, jugador2, "d", 2)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 1) == nil
  end

  test "movimiento valido rey 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "e", 2], ["r", "c", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("c", 1)
    |> Help.get_movimiento(jugador1, jugador2, "c", 2)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "c", 1) == nil
  end

  test "movimiento valido rey 3", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["d", "a", 2], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["p", "e", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 1)
    |> Help.get_movimiento(jugador1, jugador2, "f", 2)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "e", 1) == nil
  end

  test "movimiento enroque valido", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "h", 1], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["t", "b", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 1)
    |> Help.get_movimiento(jugador1, jugador2, "g", 1)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "f", 1).nombre == :torre
  end

  test "movimiento enroque valido 2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "h", 1], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["t", "h", 8], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    {:ok, _, _, tablero} =
    tablero
    |> TableroControl.pieza_tablero("e", 8)
    |> Help.get_movimiento(jugador2,jugador1, "g", 8)
    |> TableroControl.moviento(tablero)
    assert TableroControl.pieza_tablero(tablero, "f", 8).nombre == :torre
  end

  test "movimiento enroque invalido", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "h", 1], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["t", "f", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
      tablero
      |> TableroControl.pieza_tablero("e", 1)
      |> Help.get_movimiento(jugador1, jugador2, "g", 1)
      |> TableroControl.moviento(tablero)
    assert error == {:error, "camino enroque en jaque"}
  end

  test "movimiento enroque invalido_2", %{jugadores: {jugador1, jugador2}} do
    jugador1 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador1, [["t", "h", 1], ["r", "e", 1]])
    jugador2 = Ajedrez.JugadorControl.jugador_agrega_pieza_short(jugador2, [["t", "g", 7], ["r", "e", 8]])
    {tablero, jugador1, jugador2} = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    error =
      tablero
      |> TableroControl.pieza_tablero("e", 1)
      |> Help.get_movimiento(jugador1, jugador2, "g", 1)
      |> TableroControl.moviento(tablero)
    assert error == {:error, "rey queda en jaque"}
  end

end
