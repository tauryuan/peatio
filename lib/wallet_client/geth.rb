module WalletClient
  class Geth < Base

    TOKEN_METHOD_ID = '0xa9059cbb'

    def initialize(gateway_options)
      super(gateway_options)
      @json_rpc_call_id  = 0
      @json_rpc_endpoint = URI.parse(gateway_options.fetch('uri'))
    end
  end
end
