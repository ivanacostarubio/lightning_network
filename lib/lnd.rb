

module Lnd
  private

  def protect_call(failed_value, &block)
    begin
      block.call
    rescue => e
      failed_value
    end
  end

  def certificate
    # TODO: READ CERTIFICATE FROM ENV
    File.read(File.expand_path(ENV['lnd_cert']))
  end

  def credentials
    GRPC::Core::ChannelCredentials.new(certificate)
  end

  def macaroon_binary
    # TODO: READ  MACA FROM ENV
    File.read(File.expand_path(ENV['lnd_macaroon']))
  end

  def macaroon
    macaroon_binary.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
  end

  def stub
    # TODO: READ THE NODE URL FROM ENV
    Lnrpc::Lightning::Stub.new(ENV['lnd_host'],
                               credentials,
                               interceptors: [MacaroonInterceptor.new(macaroon)])
  end


  def bin_to_hex(s)
    ap s
    s.each_byte.map { |b| b.to_s(16) }.join
  end



end


