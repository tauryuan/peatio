# encoding: UTF-8
# frozen_string_literal: true

module WalletService
  Error                  = Class.new(StandardError) # TODO: Rename to Exception.
  ConnectionRefusedError = Class.new(StandardError) # TODO: Remove this.

  class << self
    #
    # Returns WalletService for given wallet.
    #
    # @param wallet [String, Symbol]
    #   The wallet record in database.
    def [](wallet)
      wallet_service = wallet.gateway.fetch('client').capitalize
      "WalletService::#{wallet_service}"
        .constantize
        .new(wallet.gateway)
    rescue NameError
      raise Error, "Wrong WalletService name #{wallet_service}"
    end
  end

  class Base

    def initialize(gateway)
      @client = WalletClient[gateway]
    end

    def collect_deposit!(deposit)
      method_not_implemented
    end

    def create_withdraw!(withdraw)
      method_not_implemented
    end

    def create_wallet!()
      method_not_implemented
    end
  end
end
