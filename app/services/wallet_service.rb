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
      "WalletService::#{wallet.gateway.fetch('client').capitalize}"
        .constantize
        .new(wallet.gateway.fetch('options'))
    end
  end

  class Base

    attr_reader :blockchain, :client

    def offload_deposit!(deposit)
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
