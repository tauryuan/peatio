module WalletClient
  class Geth < Base

    TOKEN_METHOD_ID = '0xa9059cbb'

    def initialize(*)
      super
      @json_rpc_call_id  = 0
      @json_rpc_endpoint = URI.parse(wallet.gateway.dig('options','uri'))
    end

    def create_address!(options = {})
      secret = options.fetch(:secret) { Passgen.generate(length: 64, symbols: true) }
      secret.yield_self do |password|
        { address: normalize_address(json_rpc(:personal_newAccount, [password]).fetch('result')),
          secret:  password }
      end
    end

    def create_withdrawal!(issuer, recipient, amount, options = {})
      permit_transaction(issuer, recipient)
      json_rpc(
          :eth_sendTransaction,
          [{
               from:     normalize_address(issuer.fetch(:address)),
               to:       normalize_address(recipient.fetch(:address)),
               value:    '0x' + amount.to_s(16),
               gas:      options.key?(:gas_limit) ? '0x' + options[:gas_limit].to_s(16) : nil,
               gasPrice: options.key?(:gas_price) ? '0x' + options[:gas_price].to_s(16) : nil
           }.compact]
      ).fetch('result').yield_self do |txid|
        raise WalletClient::Error, \
          "#{wallet.name} withdrawal from #{normalize_address(issuer[:address])} to #{normalize_address(recipient[:address])} failed." \
            unless valid_txid?(normalize_txid(txid))
        normalize_txid(txid)
      end
    end

    def permit_transaction(issuer, recipient)
      json_rpc(:personal_unlockAccount, [normalize_address(issuer.fetch(:address)), issuer.fetch(:secret), 5]).tap do |response|
        unless response['result']
          raise WalletClient::Error, \
            "#{wallet.name} withdrawal from #{normalize_address(issuer[:address])} to #{normalize_address(recipient[:address])} is not permitted."
        end
      end
    end

    protected

    def connection
      Faraday.new(@json_rpc_endpoint).tap do |connection|
        unless @json_rpc_endpoint.user.blank?
          connection.basic_auth(@json_rpc_endpoint.user, @json_rpc_endpoint.password)
        end
      end
    end
    memoize :connection

    def json_rpc(method, params = [])
      response = connection.post \
        '/',
        { jsonrpc: '2.0', id: @json_rpc_call_id += 1, method: method, params: params }.to_json,
        { 'Accept'       => 'application/json',
          'Content-Type' => 'application/json' }
      response.assert_success!
      response = JSON.parse(response.body)
      response['error'].tap { |error| raise Error, error.inspect if error }
      response
    end

    def normalize_address(address)
      address.downcase
    end

    def normalize_txid(txid)
      txid.downcase
    end

    def valid_address?(address)
      address.to_s.match?(/\A0x[A-F0-9]{40}\z/i)
    end

    def valid_txid?(txid)
      txid.to_s.match?(/\A0x[A-F0-9]{64}\z/i)
    end
  end
end
