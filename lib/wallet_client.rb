# encoding: UTF-8
# frozen_string_literal: true

module WalletClient
  Error                  = Class.new(StandardError) # TODO: Rename to Exception.
  ConnectionRefusedError = Class.new(StandardError) # TODO: Remove this.

  class << self
    #
    # Returns API client for given gateway options hash.
    #
    # @param gateway [String, Symbol]
    #   The gateway options hash.
    # @return [BaseAPI]
    def [](gateway)
      "WalletClient::#{gateway.fetch('client').capitalize}"
        .constantize
        .new(gateway.fetch('options'))
    end
  end

  class Base
    extend Memoist

    #
    # Returns the blockchain.
    #
    # @return [gateway]
    attr_reader :gateway_options

    def initialize(gateway_options)
      @gateway_options = gateway_options
    end
  end
end
