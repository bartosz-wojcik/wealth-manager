class Currency < ApplicationRecord
  def full_name
    "#{description} (#{name})"
  end

  def get_latest_rate(relative_to)
    # TODO: implement getting the actual rate from the DB
  end
end
