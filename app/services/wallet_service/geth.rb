# encoding: UTF-8
# frozen_string_literal: true

module WalletService
  class Geth < Base

    def create_address(options = {})
      client.create_address!(options)
    end

    def collect_deposit!(deposit, options={})
      destination_address = destination_wallet(deposit).address
      if deposit.currency.code.eth?
        collect_eth_deposit!(deposit, destination_address)
      else
        collect_erc20_deposit!(deposit, destination_address)
      end
    end

    private

    def collect_eth_deposit!(deposit, destination_address, options={})
      # Default values for Ethereum tx fees.
      options = { gas_limit: 30000, gas_price: 1 }.merge options

      # We can't collect all funds we need to subtract gas fees.
      amount = deposit.amount_to_base_unit! - options[:gas_limit] * options[:gas_price]
      pa = deposit.account.payment_address

      client.create_withdrawal!(
        { address: pa.address, secret: pa.secret },
        { address: destination_address},
        amount,
        options
      )
    end

    def collect_erc20_deposit!(deposit, destination_address)
      method_not_implemented
    end

    def destination_wallet(deposit)
      # TODO: Dynamicly check wallet balance and select where to send funds.
      # For keeping it simple we will collect all funds to hot wallet.
      Wallet
        .active
        .withdraw
        .find_by(blockchain_key: deposit.currency.blockchain_key, kind: :hot )
    end
  end
end
