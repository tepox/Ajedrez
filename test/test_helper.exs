ExUnit.start()
defmodule Help do
  def get_movimiento(pieza, jugador1, jugador2, n_h, n_v) do
    %Movimiento{
      jugador1: jugador1,
      jugador2: jugador2,
      pieza: pieza,
      p_horizontal: n_h,
      p_vertical: n_v
    }
  end
end
