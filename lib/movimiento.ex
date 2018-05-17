defmodule Movimiento do
   @moduledoc """
  Documentation for Movimiento.
  """
  defstruct pieza: %Pieza{},
            jugador1: nil,
            jugador2: nil,
            p_horizontal: nil,
            p_vertical: nil
end
