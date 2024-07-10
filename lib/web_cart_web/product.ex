defmodule WebCartWeb.Product do
  defstruct [:id, :name, :price]

  def new(id, name, price) do
    %__MODULE__{
      id: id,
      name: name,
      price: price
    }
  end
end
