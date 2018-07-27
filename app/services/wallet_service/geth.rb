# encoding: UTF-8
# frozen_string_literal: true

module WalletService
  class Geth < Base

    def create_address(options = {})
      @client.create_address!(options)
    end

    def collect_deposit!(deposit)
      if deposit.currency.code.eth?
        collect_eth_deposit!(deposit)
      else
        collect_erc20_deposit!(deposit)
      end
    end

    private

    def collect_eth_deposit!(deposit)

    end

    def collect_erc20_deposit!(deposit)

    end


  end
end
