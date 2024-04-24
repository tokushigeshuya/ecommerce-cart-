class Admin::ProductsController < ApplicationController
  # deviseメソッド adminユーザーかどうか確認
  before_action :authenticate_admin!
  # 重複する処理をまとめる
  before_action :set_product, only: [:show,:edit,:update]
  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product)
    else 
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    # newで送信
    params.require(:product).permit(:name, :description, :price, :stock)
  end
end
