defmodule WebCartWeb.CartServer do
  use GenServer

  alias WebCartWeb.{Product, CartItem}

  # Client API ##########

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    products = %{
      "GR1" => Product.new("GR1", "Green tea", 3.11),
      "SR1" => Product.new("SR1", "Strawberries", 5.00),
      "CF1" => Product.new("CF1", "Coffee", 11.23)
    }
    {:ok, %{products: products, cart: %{}, discount_mode: "enabled", total: 0.00}}
  end

  def get_products do
    GenServer.call(__MODULE__, :get_products)
  end

  def get_cart do
    GenServer.call(__MODULE__, :get_cart)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def add_to_cart(product_id, quantity \\ 1) do
    GenServer.call(__MODULE__, {:add_to_cart, product_id, quantity})
  end

  def drop_item_count(product_id, quantity \\ -1) do
    GenServer.call(__MODULE__, {:drop_item_count, product_id, quantity})
  end

  def remove_from_cart(product_id) do
    GenServer.call(__MODULE__, {:remove_from_cart, product_id})
  end

  def empty_cart() do
    GenServer.call(__MODULE__, :empty_cart)
  end


  def calculate_total() do
    GenServer.call(__MODULE__, :calculate_total)
  end

  def toggle_discount() do
    GenServer.cast(__MODULE__, :toggle_discount)
  end

  # Sever callbacks ##########

  def handle_call(:get_products, _from, state) do
    {:reply, state.products, state}
  end

  def handle_call(:get_cart, _from, state) do
    {:reply, state.cart, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_to_cart, product_id, quantity}, _from, state) do
    product = Map.get(state.products, product_id)
    item = compose_cart_item(product, quantity, state.cart, state.discount_mode)

    {:reply, :ok, %{state | cart: Map.put(state.cart, product_id, item)}}
  end

  def handle_call({:drop_item_count, product_id, quantity}, _from, state) do

    updated_cart = case Map.get(state.cart[product_id]||%{}, :quantity) do
      nil ->
        state.cart
      1 ->
        Map.delete(state.cart, product_id)
      _ ->
        compose_cart_item(state.products[product_id], quantity, state.cart, state.discount_mode)
        |>(&Map.put(state.cart, product_id, &1)).()
    end
    {:reply, :ok, %{state | cart: updated_cart}}
  end

  def handle_call({:remove_from_cart, product_id}, _from, state) do
    {:reply, :ok, %{state | cart: Map.delete(state.cart, product_id)}}
  end

  def handle_call(:empty_cart, _from, state) do
    {:reply, :ok, %{state | cart: %{}}}
  end

  def handle_call(:calculate_total, _from, state) when state.cart == %{} do
    {:reply, 0.00, state}
  end

  def handle_call(:calculate_total, _from, state) do
    total = Enum.reduce(Map.values(state.cart), 0, fn x, acc ->
      acc + (if state.discount_mode == "enabled" && x.price != "-" do
        x.price * x.quantity
        else
        x.default_price * x.quantity
        end)
    end)
    {:reply, Float.round(total, 2), %{state | total: Float.round(total, 2)}}
  end

  def handle_cast(:toggle_discount, state) do
    discount_mode = case state.discount_mode do
      "enabled" ->
        "disabled"
      _ ->
        "enabled"
    end
    {:noreply, %{state |discount_mode: discount_mode}}
  end

  # Additional functions ##########
  defp compose_cart_item(product, quantity, cart, "enabled") do

    new_quantity = (Map.get(cart[product.id]||%{}, :quantity, 0) + quantity)

    price_incl_discount =
      case %{product.id => new_quantity} do
        %{"GR1" => new_quantity} ->
          if new_quantity>1, do: Float.round(product.price/2, 2), else: product.price
        %{"SR1" => new_quantity} ->
          if new_quantity>=3, do: 4.50, else: product.price
        %{"CF1" => new_quantity} ->
          if new_quantity>=3, do: Float.round(product.price*(2/3), 2), else: product.price
        _other ->
          product.price
      end

    %CartItem{id: product.id, name: product.name, default_price: product.price, price: price_incl_discount, quantity: new_quantity}

  end

  defp compose_cart_item(product, quantity, cart, _discount_mode) do
    %CartItem{id: product.id, name: product.name, default_price: product.price, price: product.price, quantity: Map.get(cart[product.id]||%{}, :quantity, 0) + quantity}
  end
end
