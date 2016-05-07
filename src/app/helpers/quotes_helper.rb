module QuotesHelper
  AVAILABLE_QUOTES = [
    {
      :quote  => 'Surplus wealth is a sacred trust which its possessor is bound to administer in his lifetime for the good of the community.',
      :author => 'Andrew Carnegie'
    },
    {
      :quote  => 'Wealth is the product of man\'s capacity to think.',
      :author => 'Ayn Rand'
    },
    {
      :quote  => 'Rich people have small TVs and big libraries, and poor people have small libraries and big TVs.',
      :author => 'Zig Ziglar'
    },
    {
      :quote  => 'Being rich is not about how much money you have or how many homes you own; it\'s the freedom to buy any book you want without looking at the price and wondering if you can afford it.',
      :author => 'John Waters'
    },
    {
      :quote  => 'A man is rich in proportion to the number of things which he can afford to let alone.',
      :author => 'Henry David Thoreau'
    },
    {
      :quote  => 'I\'d like to live as a poor man with lots of money.',
      :author => 'Pablo Picasso'
    },
    {
      :quote  => 'Everyday is a bank account, and time is our currency. No one is rich, no one is poor, we\'ve got 24 hours each.',
      :author => 'Christopher Rice'
    }
  ]

  def self.get_one
    AVAILABLE_QUOTES[rand(AVAILABLE_QUOTES.size)]
  end
end
