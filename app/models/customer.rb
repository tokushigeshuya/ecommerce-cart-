class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # バリデーション設定（name と status が空の場合）
  with_options presence: true do
    validates :name
    validates :status
  end

  # enum
  enum status: {
    normal: 0, # 通常
    with_drawn: 1, # 退会
    banned: 2 # 停止
  }

  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy

  # カート内商品の情報を配列で返すメソッド
  def line_items_checkout
    cart_items.map do |cart_item|
      {
        quantity: cart_item.quantity,
        price_data: {
          currency: 'jpy',
          unit_amount: cart_item.product.price,
          product_data: {
            name: cart_item.product.name,
            metadata: {
              product_id: cart_item.product_id
            }
          }
        }
      }
    end
  end
end
