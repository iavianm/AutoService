class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: %i[ show edit update destroy ]
  
  def index
    # binding.pry
    @search = Order.ransack(params[:q])
    @orders = @search.result(distinct: true)

    # @search.build_condition

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def show
  end

  def new
    if @cart.line_items.empty?
      redirect_to categories_path, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to categories_path, notice: 'Thank you for your order.' }
        format.json { render :show, status: :created, location: @order }
      else
        @cart = current_cart
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :email, :pay_type, :category_id)
  end

  def ensure_cart_isnt_empty
    if @cart.line_items.empty?
      redirect_to categories_url, notice: 'Your cart is empty'
    end
  end

end
