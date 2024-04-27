class Customer::CheckoutsController < ApplicationController
  before_action :authenticate_customer!

  def create
    line_items = current_customer.line_items_checkout
    session = create_session(line_items)
    redirect_to session.url, allow_other_host: true # 異なるホストへのリダイレクトを許可
  end

  private

  def create_session(line_items)
    Stripe::Checkout::Session.create(
      # チェックアウトセッションを参照するためのid（顧客id）
      client_reference_id: current_customer.id,
      # 顧客のメールアドレス
      customer_email: current_customer.email,
      # モード
      mode: 'payment',
      # 受け入れ可能な支払い方法
      payment_method_types: ['card'],
      # 購入商品
      line_items:,
      # 配送先住所として入力できる国
      shipping_address_collection: {
        allowed_countries: ['JP']
      },
      # 配送料などのパラメータ設定
      shipping_options: [
        {
          shipping_rate_data: {
            type: 'fixed_amount',
            fixed_amount: {
              amount: 500,
              currency: 'jpy'
            },
            display_name: '全国一律'
          }
        }
      ],
      # 支払い完了後のURL
      success_url: root_url,
      # 決済キャンセル後のURL
      cancel_url: "#{root_url}cart_items"
    )
  end
end
