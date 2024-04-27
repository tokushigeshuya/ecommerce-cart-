class Order < ApplicationRecord
  belongs_to :customer

  enum status: {
    # 入金待ち
    waiting_payment: 0,
    # 入金確認
    confirm_payment: 1,
    # 出荷済み
    shipped: 2,
    # 配送中
    out_of_delivery: 3,
    # 配達済み
    delivered: 4
  }
  has_many :order_details, dependent: :destroy
end
