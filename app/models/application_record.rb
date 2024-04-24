class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # created_at の値を 降順 で並び替える
  scope :latest, -> { order(created_at: :desc) }
end
