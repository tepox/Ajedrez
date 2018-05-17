defmodule TableroControl do
   @moduledoc """
  Documentation for TableroControl.
  """
  alias Ajedrez.JugadorControl, as: JugadorC
  alias Ajedrez.PiezaControl, as: PiezaC

  @pos_inicial_jugador1 [
    ["t", "a",  1], ["c", "b",  1], ["a", "c",  1], ["d", "d",  1],
    ["r", "e",  1], ["a", "f",  1], ["c", "g",  1], ["t", "h",  1],
    ["p", "a",  2], ["p", "b",  2], ["p", "c",  2], ["p", "d",  2],
    ["p", "e",  2], ["p", "f",  2], ["p", "g",  2], ["p", "h",  2]]

  @pos_inicial_jugador2 [
    ["t", "a",  8], ["c", "b",  8], ["a", "c",  8], ["d", "d",  8],
    ["r", "e",  8], ["a", "f",  8], ["c", "g",  8], ["t", "h",  8],
    ["p", "a",  7], ["p", "b",  7], ["p", "c",  7], ["p", "d",  7],
    ["p", "e",  7], ["p", "f",  7], ["p", "g",  7], ["p", "h",  7]]

  @tablero_horizontal ["a", "b", "c", "d", "e", "f", "g", "h"]

  def moviento(movimiento, tablero_actual) do
    with {:ok, _} <- pieza_correcta(movimiento),
         {:ok, _} <- movimiento_valido(movimiento, tablero_actual),
         {:ok, _} <- rey_no_jaque(movimiento, tablero_actual)
    do
      {:ok, actualiza_jugador_movimiento(movimiento, tablero_actual),
           actualiza_jugador_espera(movimiento, tablero_actual),
           actualiza_tablero(movimiento, tablero_actual)}
    else
      error -> error
    end
  end

  defp pieza_correcta(movimiento) do
    with {:ok, _} <- pieza_no_nil(movimiento),
         {:ok, _} <- pieza_pertenece_al_jugador(movimiento)
         do
          {:ok, "pieza correcta"}
         else
          error -> error
    end
  end

  defp pieza_no_nil(%Movimiento{pieza: p}) do
     if p != nil do
      {:ok , "Pieza es valida"}
    else
      {:error, "Pieza es nil"}
     end
  end

  defp pieza_pertenece_al_jugador(%Movimiento{jugador1: jugador, pieza: p}) do
    if  jugador.piezas |> Enum.any?(fn (p_j) ->
      p_j.nombre == p.nombre and
       p_j.p_horizontal == p.p_horizontal and
       p_j.p_vertical == p.p_vertical end) do
        {:ok , "Pieza si pertenece al jugador"}
       else
        {:error, "Pieza no pertenece al jugador"}
      end
  end

  defp rey_no_jaque(movimiento = %Movimiento{pieza: %Pieza{nombre: :rey}}, tablero_actual) do
    j_r = actualiza_jugador_movimiento(movimiento, tablero_actual)
    j = actualiza_jugador_espera(movimiento, tablero_actual)
    t_a = actualiza_tablero(movimiento, tablero_actual)
    if en_jaque?(t_a , j_r, j) do
      {:error, "rey queda en jaque"}
     else
      {:ok, "rey no queda en jaque"}
     end
  end

  defp rey_no_jaque(%Movimiento{jugador1: jugador_rey,  jugador2: jugador}, tablero_Actual) do
    if en_jaque?(tablero_Actual, jugador_rey, jugador) do
      {:error, "rey queda en jaque"}
     else
      {:ok, "rey no queda en jaque"}
     end
  end


  def en_jaque_mate?(tablero_actual, jugador_rey, jugador) do
    if en_jaque?(tablero_actual, jugador_rey, jugador) do
      jugador_rey
      |> JugadorC.get_rey()
      |> get_posiciones_rey(tablero_actual)
      |> Enum.all?(fn ({n_h, n_v}) ->
        rey = JugadorC.get_rey(jugador_rey)
        rey_n = actualiza_pieza(rey, n_h, n_v)
        jugador_rey_n = JugadorC.jugador_actualiza_pieza(jugador_rey, rey_n, rey)
        en_jaque?(tablero_actual, jugador_rey_n, jugador)
      end)
    end
  end

  defp en_jaque?(tablero_actual, jugado_rey, jugador) do
    rey = JugadorC.get_rey(jugado_rey)
    Enum.any?(jugador.piezas, fn (pieza) ->
      m = %Movimiento{
        jugador1: jugador,
        jugador2: jugado_rey,
        pieza: pieza,
        p_horizontal: rey.p_horizontal,
        p_vertical: rey.p_vertical
        }
      case movimiento_valido(m, tablero_actual) do
        {:ok, _} -> true
        _ -> false
      end
    end)
  end

defp movimiento_valido(
  %Movimiento{
    pieza: peon = %Pieza{nombre: :peon , p_horizontal: n_h},
    jugador1: jugador,
    p_horizontal: n_h,
    p_vertical: n_v
  },
    tablero_actual
   ) do
    with  {:ok, _} <- PiezaC.peon_avanza(peon.p_vertical, n_v, jugador),
          {:ok, _} <- PiezaC.movimiento_pieza_valido(peon, n_h, n_v),
          {:ok, _} <- obstrucion_piezas(peon, tablero_actual, n_h, n_v),
          {:ok, _} <- espacion_valido(tablero_actual, n_h, n_v)
    do
      {:ok, "moivimiento correcto"}
    else
      error -> error
    end
end

defp movimiento_valido(
    %Movimiento{
      pieza: peon = %Pieza{nombre: :peon},
      jugador1: jugador,
      p_horizontal: n_h,
      p_vertical: n_v
    },
    tablero_actual
    ) do
    with  {:ok, _} <- PiezaC.peon_avanza(peon.p_vertical, n_v, jugador),
          {:ok, _} <- PiezaC.movimiento_pieza_valido(peon, n_h, n_v),
          {:ok, _} <- obstrucion_piezas(peon, tablero_actual, n_h, n_v),
          {:ok, _} <- captura_valida(peon, tablero_actual, n_h, n_v)
    do
      {:ok, "moivimiento correcto"}
    else
      error -> error
    end
end

defp movimiento_valido(
        movimiento = %Movimiento{
           pieza: rey = %Pieza{nombre: :rey},
           p_horizontal: n_h
         },
         tablero_actual
       ) do

        if PiezaC.enroque?(rey, tablero_actual, n_h) do
          movimiento_valido_rey_enroque(movimiento, tablero_actual)
        else
          movimiento_valido_rey(movimiento, tablero_actual)
        end
  end

  defp movimiento_valido(
         %Movimiento{
           pieza: caballo = %Pieza{nombre: :caballo},
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do

        with {:ok, _ } <- PiezaC.movimiento_pieza_valido(caballo, n_h, n_v),
             {:ok, _ } <- espacion_valido(tablero_actual, n_h, n_v),
             {:ok, _ } <- captura_valida(caballo, tablero_actual, n_h, n_v)
        do
          {:ok, "moivimiento correcto"}
        else
          error -> error
        end
  end

  defp movimiento_valido(
         %Movimiento{
           pieza: pieza,
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do
    with {:ok, _} <- PiezaC.movimiento_pieza_valido(pieza, n_h, n_v),
         {:ok, _} <- obstrucion_piezas(pieza, tablero_actual, n_h, n_v),
         {:ok, _} <- espacion_valido(tablero_actual, n_h, n_v),
         {:ok, _} <- captura_valida(pieza, tablero_actual, n_h, n_v)
    do
      {:ok, "moivimiento correcto"}
    else
      error -> error
    end

    case {PiezaC.movimiento_pieza_valido(pieza, n_h, n_v),
          obstrucion_piezas(pieza, tablero_actual, n_h, n_v),
          espacion_valido(tablero_actual, n_h, n_v),
          captura_valida(pieza, tablero_actual, n_h, n_v)} do
      {a, _, _, _} when a == false ->
        {:error, "no es posible el movimiento"}

      {_, b, _, _} when b == true ->
        {:error, "pieza obstruccion"}

      {_, _, c, d} when (c or d) == false ->
        {:error, "captura invalida, espacio invalido"}

      _ ->
        {:ok, "moivimiento correcto"}
    end
  end

  defp movimiento_valido_rey_enroque(
    %Movimiento{
      pieza: rey = %Pieza{nombre: :rey},
      p_horizontal: n_h,
      p_vertical: n_v,
      jugador1: jugador1,
      jugador2: jugador2
    },
    tablero_actual) do
      with  {:ok, _} <- obstrucion_piezas(rey, tablero_actual, n_h, n_v),
            {:ok, _} <- enroque_libre(tablero_actual, n_h, jugador1, jugador2)
      do
        {:ok, "moivimiento correcto"}
      else
        error -> error
      end
  end

  defp movimiento_valido_rey(
    %Movimiento{
      pieza: rey = %Pieza{nombre: :rey},
      p_horizontal: n_h,
      p_vertical: n_v,
    },
    tablero_actual) do
      with  {:ok, _} <- PiezaC.movimiento_pieza_valido(rey, n_h, n_v),
            {:ok, _} <- captura_valida(rey, tablero_actual, n_h, n_v)
      do
        {:ok, "moivimiento correcto"}
      else
        error -> error
      end
  end

  defp actualiza_jugador_movimiento(
         %Movimiento{
           pieza: pieza = %Pieza{nombre: :rey},
           jugador1: jugador1,
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do

        if PiezaC.enroque?(pieza, tablero_actual, n_h) do
          torre = get_torre_enroque(tablero_actual, pieza, n_h)
          torre_a = actualiza_pieza(torre, get_posicion_torre_enroque(pieza, n_h))
          pieza_a = actualiza_pieza(pieza, n_h, n_v)
          jugador1
          |> JugadorC.jugador_actualiza_pieza(pieza_a, pieza)
          |> JugadorC.jugador_actualiza_pieza(torre_a, torre)
        else
          pieza_tablero = pieza_tablero(tablero_actual, {n_h, n_v})
          pieza_a = actualiza_pieza(pieza, n_h, n_v)
          jugador1 = JugadorC.jugador_actualiza_pieza(jugador1, pieza_a, pieza)
          if pieza_tablero != nil do
            Map.put(jugador1, :capturas, jugador1.capturas ++ [pieza_tablero])
          else
            jugador1
          end
        end
  end

  defp actualiza_jugador_movimiento(
         %Movimiento{
           pieza: pieza,
           jugador1: jugador1,
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do
    pieza_tablero = pieza_tablero(tablero_actual, {n_h, n_v})
    jugador1 = JugadorC
    .jugador_actualiza_pieza(jugador1, actualiza_pieza(pieza, n_h, n_v), pieza)

    if pieza_tablero != nil do
      Map.put(jugador1, :capturas, jugador1.capturas ++ [pieza_tablero])
    else
      jugador1
    end
  end

  defp actualiza_jugador_espera(
         %Movimiento{
           jugador2: jugador2,
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do
        JugadorC
        .jugador_elimina_pieza(jugador2, pieza_tablero(tablero_actual, {n_h, n_v}))
  end

  defp actualiza_tablero(
         %Movimiento{
           pieza: pieza = %Pieza{p_horizontal: v_h, p_vertical: v_v, nombre: :rey},
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do

    if PiezaC.enroque?(pieza, tablero_actual, n_h) do
      torre = get_torre_enroque(tablero_actual, pieza, n_h)
      torre_a = actualiza_pieza(torre, get_posicion_torre_enroque(pieza, n_h))
      pieza = actualiza_pieza(pieza, n_h, n_v)

      tablero_actual
      |> actualiza_pieza_tablero(pieza)
      |> actualiza_pieza_tablero(torre_a)
      |> actualiza_pieza_nil_tablero(torre.p_horizontal, torre.p_vertical)
    else
      pieza = actualiza_pieza(pieza, n_h, n_v)

      tablero_actual
      |> actualiza_pieza_tablero(pieza)
      |> actualiza_pieza_nil_tablero(v_h, v_v)
    end
  end

  defp actualiza_tablero(
         %Movimiento{
           pieza: pieza = %Pieza{p_horizontal: v_h, p_vertical: v_v},
           p_horizontal: n_h,
           p_vertical: n_v
         },
         tablero_actual
       ) do
    pieza = actualiza_pieza(pieza, n_h, n_v)

    tablero_actual
    |> actualiza_pieza_tablero(pieza)
    |> actualiza_pieza_nil_tablero(v_h, v_v)
  end



  defp captura_valida(
         %Pieza{nombre: :peon, jugador: jugador, p_horizontal: p_h},
         tablero,
         n_h,
         n_v
       ) do
    pieza_tablero = pieza_tablero(tablero, {n_h, n_v})
    res=
    p_h != n_h && pieza_tablero != nil && jugador.nombre != pieza_tablero.jugador.nombre
    if res, do: {:ok, "captura valida"}, else: {:error, "captura invalida"}
  end

  defp enroque_libre(tablero_actual, n_h, jugador1, jugador2) do
      rey1 = JugadorC.get_rey(jugador1)
      res =
      rey1.p_horizontal
      |> posiciones(rey1.p_vertical, n_h, rey1.p_vertical)
      |> Enum.scan({tablero_actual, jugador1, jugador2},
          & enroque_libre_evalua_posicion(&1, &2)
      )
    |> Enum.all?( fn x -> x != {:error , "rey queda en jaque"}end)
    if res, do: {:ok, "camino enroque libre"}, else: {:error, "camino enroque en jaque"}
  end

defp enroque_libre_evalua_posicion({h, v}, cc) do
  case cc do
    {t_a, j1, j2} ->
      rey = JugadorC.get_rey(j1)
      mov = %Movimiento{
        jugador1: j1,
        jugador2: j2,
        pieza: rey,
        p_horizontal: h,
        p_vertical: v
      }
      case moviento(mov, t_a) do
          {:error, _error} ->
            {:error, "rey queda en jaque"}
          {:ok, j1, j2, t_an} ->
            {t_an, j1, j2}
        end
      error -> error
    end
  end

  defp espacion_valido(tablero, n_h, n_v) do
    pieza = pieza_tablero(tablero, {n_h, n_v})
    if pieza == nil, do: {:ok, "espacio valido"}, else: {:error, "espacio invalido"}
  end

  defp captura_valida(%Pieza{jugador: jugador}, tablero, n_h, n_v) do
    pieza_tablero = pieza_tablero(tablero, {n_h, n_v})
    if pieza_tablero != nil && jugador.nombre != pieza_tablero.jugador.nombre do
      {:ok, "captura valida"}
    else
      {:error, "captura invalida"}
    end
  end

  defp captura_o_espacio_valido(pieza, tablero, n_h, n_v) do
    case {espacion_valido(tablero, n_h, n_v),
     captura_valida(pieza, tablero, n_h, n_v)} do
    {{:ok, _}, _} -> {:ok, "casilla correcta"}
    {_, {:ok, _}} -> {:ok, "casilla correcta"}
                _ -> {:error, "captura invalida, espacio invalido"}
    end
  end

  defp obstrucion_piezas(
         %Pieza{p_horizontal: p_h, p_vertical: p_v},
         tablero,
         n_h,
         n_v
       ) do

    posiciones = posiciones(p_h, p_v, n_h, n_v)
    piezas_obstruccion = Enum.filter(posiciones, &(pieza_tablero(tablero, &1) != nil))
    if length(piezas_obstruccion) != 0, do: {:ok, "camino libre"}, else: {:error, "pieza obstruccion"}
  end

  def pieza_tablero(tablero, p_h, p_v) when is_integer(p_v) do
    Map.get(Map.get(tablero, String.to_atom(p_h)), p_v)
  end

  defp pieza_tablero(tablero, {a, b}) do
    pieza_tablero(tablero, a, b)
  end


  defp posiciones(p_h, actual, p_h, nuevo) do
    cond do
      actual < nuevo ->
        actual..nuevo
        |> Enum.to_list()
        |> Enum.filter(&(actual < &1 && nuevo > &1))
        |> Enum.flat_map(&[{p_h, &1}])

      actual > nuevo ->
        nuevo..actual
        |> Enum.to_list()
        |> Enum.filter(&(nuevo < &1 && actual > &1))
        |> Enum.flat_map(&[{p_h, &1}])

      true ->
        []
    end
  end

  defp posiciones(actual, p_v, nuevo, p_v) do
    cond do
      actual < nuevo ->
        @tablero_horizontal
        |> Enum.filter(&(actual < &1 && nuevo > &1))
        |> Enum.flat_map(&[{&1, p_v}])

      actual > nuevo ->
        @tablero_horizontal
        |> Enum.filter(&(nuevo < &1 && actual > &1))
        |> Enum.flat_map(&[{&1, p_v}])

      true ->
        []
    end
  end

  defp posiciones(x, y, x1, y1)  when x <  x1 and y < y1 do
    {lista, _} =
      @tablero_horizontal
      |> Enum.filter(&(x < &1 && x1 > &1))
      |> Enum.flat_map_reduce(
        y + 1,
        &{[{&1, &2}], &2 + 1}
      )
    lista
  end

  defp posiciones(x, y, x1, y1)  when x <  x1 and y > y1 do
    {lista, _} =
      @tablero_horizontal
      |> Enum.filter(&(x < &1 && x1 > &1))
      |> Enum.flat_map_reduce(
        y - 1,
        &{[{&1, &2}], &2 - 1}
      )
    lista
  end

  defp posiciones(x, y, x1, y1)  when x >  x1 and y < y1 do
    {lista, _} =
      @tablero_horizontal
      |> Enum.reverse()
      |> Enum.filter(&(x1 < &1 && x > &1))
      |> Enum.flat_map_reduce(
        y + 1,
        &{[{&1, &2}], &2 + 1}
      )
    lista
  end

  defp posiciones(x, y, x1, y1)  when x >  x1 and y > y1 do
    {lista, _} =
      @tablero_horizontal
      |> Enum.reverse()
      |> Enum.filter(&(x1 < &1 && x > &1))
      |> Enum.flat_map_reduce(
        y - 1,
        &{[{&1, &2}], &2 - 1}
      )
    lista
  end

  defp actualiza_pieza_nil_tablero(tablero, p_h, p_v) do
    Map.put(
      tablero,
      String.to_atom(p_h),
      Map.put(Map.get(tablero, String.to_atom(p_h)), p_v, nil)
    )
  end

  defp actualiza_pieza_tablero(tablero, [head | tail]) do
    actualiza_pieza_tablero(
      Map.put(
        tablero,
        String.to_atom(head.p_horizontal),
        Map.put(Map.get(tablero, String.to_atom(head.p_horizontal)), head.p_vertical, head)
      ),
      tail
    )
  end

  defp actualiza_pieza_tablero(tablero, []) do
    tablero
  end

  defp actualiza_pieza_tablero(tablero, pieza) do
    actualiza_pieza_tablero(tablero, [pieza])
  end

  defp actualiza_pieza(nil, _, _) do
    nil
  end

  defp actualiza_pieza(pieza, n_h, n_v) do
    pieza |> Map.put(:p_horizontal, n_h) |> Map.put(:p_vertical, n_v)
    |> Map.put(:contador, pieza.contador + 1)
  end

  defp actualiza_pieza(pieza, {n_h, n_v}) do
    pieza |> Map.put(:p_horizontal, n_h) |> Map.put(:p_vertical, n_v)
    |> Map.put(:contador, pieza.contador + 1)
  end

  def inicia_juego(tablero, jugador1 = %Jugador{piezas: []}, jugador2 = %Jugador{piezas: []}) do
    jugador1 =
      JugadorC.jugador_agrega_pieza_short(jugador1, @pos_inicial_jugador1)

    jugador2 =
      JugadorC.jugador_agrega_pieza_short(jugador2, @pos_inicial_jugador2)

    tablero = actualiza_pieza_tablero(tablero, jugador1.piezas ++ jugador2.piezas)
    {tablero, jugador1, jugador2}
  end

  def inicia_juego(tablero, jugador1, jugador2) do
    tablero = actualiza_pieza_tablero(tablero, jugador1.piezas ++ jugador2.piezas)
    {tablero, jugador1, jugador2}
  end


  defp get_posiciones_rey(rey, tablero_actual) do
    p_h = horizontal_integer(rey.p_horizontal)
    p_v = rey.p_vertical
    pos =
    [[p_h + 1, p_v + 1], [p_h + 1, p_v], [p_h + 1, p_v - 1], [p_h, p_v - 1], [p_h - 1, p_v - 1], [p_h - 1, p_v], [p_h - 1, p_v + 1], [p_h, p_v + 1]]
    |> Enum.filter(fn ([h, v]) -> (h > 96 and h < 105 and v > 0 and v < 9)  end)
    |> Enum.map(fn ([h, v]) -> {<<h::utf8>>, v} end)
    |> Enum.filter(fn (p) -> pieza_tablero(tablero_actual, p) == nil end)
    pos
  end

  defp get_torre_enroque(tablero, rey, "g") do
    pieza_tablero(tablero, "h", rey.p_vertical)
  end

  defp get_torre_enroque(tablero, rey, "c") do
    pieza_tablero(tablero, "a", rey.p_vertical)
  end

  defp get_posicion_torre_enroque(rey, "g") do
    {"f", rey.p_vertical}
  end

  defp get_posicion_torre_enroque(rey, "c") do
    {"d", rey.p_vertical}
  end

  defp horizontal_integer(p_h) do
    <<x::utf8>> = p_h
    x
  end
end
