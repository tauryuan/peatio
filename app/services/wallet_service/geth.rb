# encoding: UTF-8
# frozen_string_literal: true

module WalletService
  class Geth < Base

    DEFAULT_GAS_FEES_LIMIT = 30_000

    def create_address(options = {})
      client.create_address!(options)
    end

    def collect_deposit!(deposit, options={})
      destination_address = destination_wallet(deposit).address
      if deposit.currency.code.eth?
        collect_eth_deposit!(deposit, destination_address, options)
      else
        collect_erc20_deposit!(deposit, destination_address, options)
      end
    end

    private

    def collect_eth_deposit!(deposit, destination_address, options={})
      # Default values for Ethereum tx fees.
      options = { gas_limit: DEFAULT_GAS_FEES_LIMIT }.merge options

      # We can't collect all funds we need to subtract gas fees.
      amount = deposit.amount_to_base_unit! - options[:gas_limit]
      pa = deposit.account.payment_address

      client.create_eth_withdrawal!(
        { address: pa.address, secret: pa.secret },
        { address: destination_address},
        amount,
        options
      )
    end

    def collect_erc20_deposit!(deposit, destination_address, options={})
      pa = deposit.account.payment_address

      # Deposit eth for paying fees for contract execution.
      deposit_eth_for_fees(pa.address)

      client.create_erc20_withdrawal!(
          { address: pa.address, secret: pa.secret },
          { address: destination_address},
          deposit.amount_to_base_unit!,
          options
      )
    end

    def destination_wallet(deposit)
      # TODO: Dynamicly check wallet balance and select where to send funds.
      # For keeping it simple we will collect all funds to hot wallet.
      Wallet
        .active
        .withdraw
        .find_by(blockchain_key: deposit.currency.blockchain_key, kind: :hot)
    end

    def eth_fees_wallet
      Wallet
        .active
        .withdraw
        .find_by(currency_id: :eth, kind: :hot)
    end

    def deposit_eth_for_fees(destination_address)
      fees_wallet = eth_fees_wallet

      client.create_eth_withdrawal!(
          { address: fees_wallet.address, secret: fees_wallet.secret },
          { address: destination_address},
          DEFAULT_GAS_FEES_LIMIT,
          options
      )
    end
  end
end
