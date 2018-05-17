defmodule Ajedrez.JugadorControl do
   @moduledoc """
  Documentation for JugadorControl.
  """

  @nombre_abreviados %{"r" => :rey, "d" => :dama, "t" => :torre, "a" => :alfil, "c"=> :caballo, "p" => :peon,
                           "R" => :rey, "D" => :dama, "T" => :torre, "A" => :alfil, "C"=> :caballo, "P" => :peon}

  @spec jugador_actualiza_pieza(map(), map(), map()):: map()
  def jugador_actualiza_pieza(jugador, pieza_n, pieza_v) do
    case jugador.piezas |> Enum.find(fn (pieza_j) -> pieza_j == pieza_v end) do
      nil -> {:error, "no se encontro pieza"}
      _ ->
      jugador |> jugador_elimina_pieza(pieza_v) |> jugador_agrega_pieza([pieza_n])
    end
  end

  @spec jugador_agrega_pieza(map(), list(map())):: map()
  def jugador_agrega_pieza(jugador, [head | tail]) do
    jugador |> Map.put(:piezas, jugador.piezas ++ [head]) |> jugador_agrega_pieza(tail)
  end
  @spec jugador_agrega_pieza(map(), []):: map()
  def jugador_agrega_pieza(jugador, []) do
    jugador
  end

  @spec jugador_elimina_pieza(map(), map()):: map()
  def jugador_elimina_pieza(jugador, pieza) do
    jugador |> Map.put(:piezas, jugador.piezas -- [pieza])
  end

  @spec get_rey(map()):: map()
  def get_rey(jugador) do
    jugador.piezas |> Enum.find(fn (pieza) -> pieza.nombre == :rey end)
  end

  @spec jugador_agrega_pieza_short(map(), list(list(binary()))):: map()
  def jugador_agrega_pieza_short(jugador, list_piezas)  do
    piezas =
    list_piezas
    |> Enum.map(fn  [nombre, p_h, p_v] ->
      %Pieza{nombre: @nombre_abreviados[nombre], p_horizontal: p_h, p_vertical: p_v, jugador: jugador}
    end)
     jugador_agrega_pieza(jugador, piezas)
  end

end
