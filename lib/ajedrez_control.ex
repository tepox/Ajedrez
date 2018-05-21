defmodule AjedrezControl do
  @moduledoc """
  Documentation for Ajedrez.
  """

  require Logger

  def inicia do

    jugador1 = %Jugador{nombre: "jugador 1", color: :blancas}
    jugador2 = %Jugador{nombre: "jugador 2", color: :negras}
    ajedrez = TableroControl.inicia_juego(%Tablero{}, jugador1, jugador2)
    imprime_tablero(ajedrez.tablero)
    juego(ajedrez, :blancas)
  end

  defp juego(ajedrez = %Ajedrez{tablero: tablero}, color) do
    movimiento_jugador = IO.gets("movimiento #{color}:\n")

    if valida_movimiento(movimiento_jugador) do
      case TableroControl.moviento(
             genera_movimiento(movimiento_jugador, get_jugador(ajedrez, color), get_jugador(ajedrez, color_siguiente(color)), tablero),
             tablero
           ) do
        {:ok, ajedrez_a} ->
          imprime_jugador(ajedrez_a.jugador1)
          imprime_jugador(ajedrez_a.jugador2)
          imprime_tablero(ajedrez_a.tablero)
          jugador_movimiento = get_jugador(ajedrez_a, color)
          jugador_espera  = get_jugador(ajedrez_a, color_siguiente(color))
          if TableroControl.en_jaque_mate?(tablero, jugador_espera, jugador_movimiento) do
            IO.puts("gana jugador #{jugador_movimiento.nombre}")
          else
            juego(ajedrez, color_siguiente(color))
          end

        {:error, mensaje} ->
          IO.puts("#{mensaje}")
          juego(tablero, color)
      end
    else
      IO.puts("movimiento mal declarado")
      juego(tablero, color)
    end
  end

  defp valida_movimiento(movimiento_jugador) do
    {_, regex} = Regex.compile("^[a-h]{1}[1-8]{1}+-[a-h]{1}[1-8]{1}")
    String.match?(movimiento_jugador, regex)
  end

  defp genera_movimiento(movimiento, jugador1, jugador2, tablero) do
    [v_h, v_v, _, n_h, n_v, _] = String.graphemes(movimiento)
    pieza = TableroControl.pieza_tablero(tablero, v_h, String.to_integer(v_v))
    %Movimiento{
      jugador1: jugador1,
      jugador2: jugador2,
      pieza: pieza,
      p_horizontal: n_h,
      p_vertical: String.to_integer(n_v)
    }
  end

  defp imprime_jugador(jugador) do
    IO.puts(
      "nombre: #{jugador.nombre}, piezas: #{length(jugador.piezas)}, capturas:#{
        length(jugador.capturas)
      } "
    )
  end

  defp imprime_tablero(tablero) do
    horizontal = ["a", "b", "c", "d", "e", "f", "g", "h"]
    vertical = [8, 7, 6, 5, 4, 3, 2, 1]

    vertical
    |> Enum.each(&(imprime_fila(&1, tablero)))
    IO.write("\n")
    Enum.each(horizontal, &(IO.write(String.pad_leading("#{&1}", 8, [" "]))))
    IO.write("\n")
  end

  defp imprime_fila(v, tablero) do
    horizontal = ["a", "b", "c", "d", "e", "f", "g", "h"]
    IO.write("\n#{v} ")
    Enum.each(horizontal, fn h ->
      case TableroControl.pieza_tablero(tablero, h, v) do
        nil -> IO.write(",      ,")
        pieza -> IO.write(String.pad_leading("#{pieza.nombre}", 8, [" "]))
      end
    end)
  end

  defp get_jugador(%Ajedrez{jugador1: jugador1 = %Jugador{color: b} }, b) do
    jugador1
  end


  defp get_jugador(%Ajedrez{jugador2: jugador2 = %Jugador{color: b}}, b) do
    jugador2
  end

  defp color_siguiente(:blancas) do
    :negras
  end

  defp color_siguiente(:negras) do
    :blancas
  end

end
