class AddMaxDepositAndGatewayToWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :max_balance, :integer,              default: 0,    null: false, after: :nsig
    add_column :wallets, :gateway,     :string,  limit: 1000, default: '{}', null: false, after: :status
  end
end
