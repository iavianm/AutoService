class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: %i[ show edit update destroy ]
  
  def index
    # @email = Order.pluck(:email)
    # sql = SELECT orders.name, services.title, categories.title FROM orders INNER JOIN line_items ON line_items.order_id = orders.ROWID INNER JOIN services ON line_items.service_id = services.ROWID INNER JOIN categories ON services.category_id = categories.ROWID;
    @sql = ("SELECT orders.name, services.title, categories.title FROM orders" "INNER JOIN line_items ON line_items.order_id = orders.ROWID" "INNER JOIN services ON line_items.service_id = services.ROWID" "INNER JOIN categories ON services.category_id = categories.ROWID")
    # @search = SELECT orders.name, services.title, categories.title FROM orders INNER JOIN line_items ON line_items.order_id = orders.ROWID INNER JOIN services ON line_items.service_id = services.ROWID INNER JOIN categories ON services.category_id = categories.ROWID;
    @search = Order.all.ransack(params[:q])
    
    @q = [1,2]
    # binding.pry
      # @search = Order.joins(:line_items).joins(:services, :categories).ransack(params[:q])
    @orders = @search.result
    @search.build_condition if @search.conditions.empty?
    @search.build_sort if @search.sorts.empty?


    # min_rating = 5
    # sql = Boroda.build do
    #   from :posts => :p
    #   left join :comments => :c
    #   on c.post_id == p.id
    #   select p.id, p.title, p.content, c.id.count => :comment_count
    #   group by p.id
    #   where (p.title.like '%programming%') | # Выбираем все посты, содержащие в заголовке 'programming'
    #         (p.rating > min_rating) # Или с рейтингом больше 5-ти
    #   order by p.created_at.desc
    #   limit 10
    #   offset 20
    # end


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
