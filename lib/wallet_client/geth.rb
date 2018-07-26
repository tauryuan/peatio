module WalletClient
  class Geth < Base

    TOKEN_METHOD_ID = '0xa9059cbb'

    def initialize(*)
      super
      @json_rpc_call_id  = 0
      @json_rpc_endpoint = URI.parse(wallet.gateway.dig('options','uri'))
    end
  end
end
