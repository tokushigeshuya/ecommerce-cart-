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
end
