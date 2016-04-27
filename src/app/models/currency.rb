class Currency < ApplicationRecord
  def full_name
    "#{description} (#{name})"
  end
end
