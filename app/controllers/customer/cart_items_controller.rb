class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: %i[increase decrease destroy]

  def index
    # ログインユーザーのカートアイテム全取得
    @cart_items = current_customer.cart_items
    @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.line_total }
  end

  def create
    # increase_or_create で商品追加or個数追加
    increase_or_create(params[:cart_item][:product_id])
    redirect_to cart_items_path, notice: 'Success add cart'
    puts "これが中身だよ: #{params[:cart_item].inspect}"
  end

  def increase
    @cart_item.increment!(:quantity, 1)
    redirect_to request.referer, notice: 'updated Success'
  end

  def decrease
    # 一つ減らす
    decrease_or_destroy(@cart_item)
    redirect_to request.referer, notice: 'updated Success'
  end

  def destroy
    @cart_item.destroy
    redirect_to request.referer, notice: 'delete Success'
  end

  private

  def set_cart_item
    # ログインユーザーがcartitemと関連を持っている場合は商品取得
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def increase_or_create(product_id)
    # 追加予定の商品を検索
    cart_item = current_customer.cart_items.find_by(product_id:)
    if cart_item
      cart_item.increment!(:quantity, 1)
    else
      # 現在ログインしている顧客に紐付け、その顧客のカートへ保存
      current_customer.cart_items.build(product_id:).save
    end
  end

  def decrease_or_destroy(cart_item)
    if cart_item.quantity > 1
      cart_item.decrement!(:quantity, 1)
    else
      # カートないから削除
      cart_item.destroy
    end
  end
end
