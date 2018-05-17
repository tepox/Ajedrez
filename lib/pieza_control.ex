defmodule Ajedrez.PiezaControl do
 @moduledoc """
  Documentation for PiezaControl.
  """

  @mov_valido {:ok, "movimiento valido"}
  @mov_invalido {:error, "movimiento invalido"}

  def movimiento_pieza_valido(
         %Pieza{nombre: :peon, p_horizontal: p_h, p_vertical: y, contador: c},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
    res =
      cond do
        x == x1 ->
          if c == 0 do
            abs(y1 - y) == 2 or  abs(y1 - y) == 1
          else
            abs(y1 - y) == 1
          end
        x + 1 == x1 || x - 1 == x1 ->
          c >= 0 && abs(y1 - y) == 1
        true ->
          false
      end
      if res, do: @mov_valido, else: @mov_invalido
  end

  def movimiento_pieza_valido(
         %Pieza{nombre: :dama, p_horizontal: p_h, p_vertical: y},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
     case (x == x1 && y != y1) || (x != x1 && y == y1) || abs(x1 - x) == abs(y1 - y) do
       true -> @mov_valido
       _    -> @mov_invalido
     end
  end

  def movimiento_pieza_valido(
         %Pieza{nombre: :rey, p_horizontal: p_h, p_vertical: y},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
    cond do
      (abs(x1 - x) == 1 && abs(y1 - y) == 1) -> @mov_valido
      (abs(x1 - x) == 1 && y == y1) ->  @mov_valido
      (abs(y1 - y) == 1 && x == x1) -> @mov_valido
      true -> @mov_invalido
    end
  end

  def movimiento_pieza_valido(
         %Pieza{nombre: :torre, p_horizontal: p_h, p_vertical: y},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
    if (x == x1 && y != y1) || (x != x1 && y == y1), do: @mov_valido, else: @mov_invalido
  end

  def movimiento_pieza_valido(
         %Pieza{nombre: :alfil, p_horizontal: p_h, p_vertical: y},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
    if abs(x1 - x) == abs(y1 - y) && x1 - x != 0, do: @mov_valido, else: @mov_invalido
  end

  def movimiento_pieza_valido(
         %Pieza{nombre: :caballo, p_horizontal: p_h, p_vertical: y},
         n_h,
         y1
       ) do
    x = horizontal_integer(p_h)
    x1 = horizontal_integer(n_h)
    res = (x1 != x && y != y1 && abs(x1 - x) + abs(y1 - y) == 3)
    if res, do: @mov_valido, else: @mov_invalido
  end

  def peon_avanza(v_v, n_v, jugador) do
    cond do
      jugador.color == :blancas and v_v < n_v  -> {:ok, "peon avanza"}
      jugador.color == :negras and v_v > n_v -> {:ok, "peon avanza"}
      true -> {:error, "peon no avanza"}
    end
  end

  def enroque?(rey = %Pieza{nombre: :rey, contador: 0}, tablero, "g") do
    torre =
       TableroControl.pieza_tablero(tablero, "h", rey.p_vertical)
    rey.contador == 0 and  torre != nil and rey.jugador.color == torre.jugador.color and
    torre.nombre == :torre and torre.contador == 0
  end

  def enroque?(rey = %Pieza{nombre: :rey, contador: 0}, tablero, "c") do
    torre =
       TableroControl.pieza_tablero(tablero, "a", rey.p_vertical)
    rey.contador == 0 and  torre != nil and rey.jugador.color == torre.jugador.color and
    torre.nombre == :torre and torre.contador == 0
  end

  def enroque?(_, _, _) do
    false
  end

  defp horizontal_integer(p_h) do
    <<x::utf8>> = p_h
    x
  end
end
