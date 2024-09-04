require 'openssl'

class JsonWebToken
  def self.encode(payload)
    private_key = OpenSSL::PKey::RSA.new(Rails.application.credentials.secret_key_base)
    JWT.encode(payload, private_key, 'RS256')
  end

  def self.decode(token)
    begin
      decoded_array = JWT.decode(token, Rails.application.credentials.secret_key_base, false, { algorithm: 'RS256' })
      if decoded_array.is_a?(Array) && decoded_array.size > 0
        payload = decoded_array[0]
        HashWithIndifferentAccess.new(payload)
      else
        puts "Decoded array is not in expected format: #{decoded_array.inspect}"
        nil
      end
    rescue JWT::VerificationError => e
      puts "JWT Verification Error: #{e.message}"
      nil
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      nil
    end
  end
end