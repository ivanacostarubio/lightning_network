class MacaroonInterceptor < GRPC::ClientInterceptor
  attr_reader :macaroon

  def initialize(macaroon)
    @macaroon = macaroon
    super
  end

  def request_response(request:, call:, method:, metadata:)
    metadata['macaroon'] = macaroon
    yield
  end
end


