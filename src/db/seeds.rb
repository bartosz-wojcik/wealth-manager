# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless AssetType.exists?
  savings     = AssetType.create name: 'Savings', description: ''
  investments = AssetType.create name: 'Investments', description: ''
  retirement  = AssetType.create name: 'Retirement', description: ''
  debt        = AssetType.create name: 'Debt', description: ''

  unless AssetCategory.exists?
    AssetCategory.create([
      {
        asset_type_id: savings.id,
        name: 'Emergency Fund',
        description: ''
      },
      {
        asset_type_id: savings.id,
        name: 'Safety Net',
        description: ''
      },
      {
        asset_type_id: savings.id,
        name: 'Other',
        description: ''
      }
    ])
    AssetCategory.create([
      {
        asset_type_id: investments.id,
        name: 'Investment Fund',
        description: ''
      },
      {
        asset_type_id: investments.id,
        name: 'Stock Market',
        description: ''
      },
      {
        asset_type_id: investments.id,
        name: 'Real Estate',
        description: ''
      },
      {
        asset_type_id: investments.id,
        name: 'Other',
        description: ''
      }
    ])
    AssetCategory.create([
      {
        asset_type_id: retirement.id,
        name: 'Retirement Fund',
        description: ''
      },
      {
        asset_type_id: retirement.id,
        name: 'Other',
        description: ''
      }
    ])
    AssetCategory.create([
      {
        asset_type_id: debt.id,
        name: 'Mortgage',
        description: ''
      },
      {
        asset_type_id: debt.id,
        name: 'Credit Cards',
        description: ''
      },
      {
        asset_type_id: debt.id,
        name: 'Short Term Loans',
        description: ''
      },
      {
        asset_type_id: debt.id,
        name: 'Other',
        description: ''
      }
    ])
  end
end

unless Currency.exists?
  Currency.create([
    {
      name: 'USD',
      symbol: '$',
      description: 'US Dollar'
    },
    {
      name: 'EUR',
      symbol: '€',
      description: 'Euro'
    },
    {
      name: 'GBP',
      symbol: '£',
      description: 'British Pound'
    },
    {
      name: 'CHF',
      symbol: 'Fr',
      description: 'Swiss Franc'
    },
    {
      name: 'PLN',
      symbol: 'zł',
      description: 'Polish Zloty'
    },
    {
      name: 'CAD',
      symbol: '$',
      description: 'Canadian Dollar'
    },
    {
      name: 'AUD',
      symbol: '$',
      description: 'Australian Dollar'
    },
    {
      name: 'JPY',
      symbol: '¥',
      description: 'Japanese Yen'
    }
  ])
end