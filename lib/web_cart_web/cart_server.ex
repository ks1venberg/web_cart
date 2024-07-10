defmodule WebCartWeb.CartServer do
  use GenServer

  alias WebCartWeb.{Product, CartItem}

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    products = %{
      1 => Product.new("GR1", "Green tea", 3.11),
      2 => Product.new("SR1", "Strawberries", 5.00),
      3 => Product.new("CF1", "Coffee", 11.23)
    }
    {:ok, %{products: products, cart: %{}, discounts: %{}}}
  end

  def get_products do
    GenServer.call(__MODULE__, :get_products)
  end

  def add_to_cart(product_id, quantity, role) do
    GenServer.call(__MODULE__, {:add_to_cart, product_id, quantity, role})
  end

  def get_cart do
    GenServer.call(__MODULE__, :get_cart)
  end

  def set_discount(role, product_id, discount_percentage) do
    GenServer.call(__MODULE__, {:set_discount, role, product_id, discount_percentage})
  end

  def handle_call(:get_products, _from, state) do
    {:reply, Map.values(state.products), state}
  end

  def handle_call({:add_to_cart, product_id, quantity, role}, _from, state) do
    product = Map.get(state.products, product_id)
    cart = state.cart

    discount = Map.get(state.discounts, {role, product_id}, 0)
    discounted_price = product.price * (1 - discount / 100)
    cart_item = %CartItem{product: %Product{product | price: discounted_price}, quantity: quantity}

    updated_cart =
      if Map.has_key?(cart, product_id) do
        %{cart | product_id => %CartItem{cart[product_id] | quantity: cart[product_id].quantity + quantity}}
      else
        Map.put(cart, product_id, cart_item)
      end

    {:reply, :ok, %{state | cart: updated_cart}}
  end

  def handle_call(:get_cart, _from, state) do
    {:reply, state.cart, state}
  end

  def handle_call({:set_discount, role, product_id, discount_percentage}, _from, state) do
    discounts = Map.put(state.discounts, {role, product_id}, discount_percentage)
    {:reply, :ok, %{state | discounts: discounts}}
  end
end
