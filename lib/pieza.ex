defmodule Pieza do
  @moduledoc """
  Documentation for Pieza.
  """
  defstruct nombre: :vacia, jugador: %Jugador{}, p_horizontal: nil, p_vertical: nil, contador: 0
end
