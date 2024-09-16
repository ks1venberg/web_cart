defmodule WebCartWeb.CartItem do
  defstruct [:id, :name, :default_price, :price, :quantity]

  def new(id, name, default_price, price, quantity \\ 1) do
    %__MODULE__{
      id: id,
      name: name,
      default_price: default_price,
      price: price,
      quantity: quantity
    }
  end
end
