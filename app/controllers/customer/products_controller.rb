class Customer::ProductsController < ApplicationController
  def index
    # productsには商品情報、sortにはソートタイプの文字列が入る
    @products, @sort = get_products(params)
  end

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
  end

  private

  def get_products(params)
    # paramsに:latest、:price_high_to_low、または:price_low_to_highが含まれていない場合、全ての商品と文字列'default'を返す。
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:params_low_to_high]
    # paramsに:latestが含まれている場合、最新の商品と文字列'latest'を返します。
    return Product.latest, 'latest' if params[:latest]
    # paramsに:price_high_to_lowが含まれている場合、価格の高い順にソートされた商品と文字列'price_high_to_low'を返す。
    return Product.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    # paramsに:price_low_to_highが含まれている場合、価格の低い順にソートされた商品と文字列'price_low_to_high'を返す。
    Product.price_low_to_high 'price_low_to_high' if params[:price_low_to_high]
  end
end
