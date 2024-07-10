defmodule WebCartWeb.CartItem do
  defstruct [:product, :quantity]

  def new(product, quantity \\ 1) do
    %__MODULE__{
      product: product,
      quantity: quantity
    }
  end
end
