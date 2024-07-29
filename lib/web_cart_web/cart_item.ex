defmodule WebCartWeb.CartItem do
  defstruct [:name, :price, :quantity]

  def new(name, price, quantity \\ 1) do
    %__MODULE__{
      name: name,
      price: price,
      quantity: quantity
    }
  end
end
