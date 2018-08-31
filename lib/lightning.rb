
ENV['GRPC_SSL_CIPHER_SUITES'] = "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256"

require 'rpc_pb'
require 'rpc_services_pb'
require 'grpc'
require 'macaroon_interceptor'
require 'lnd'
require 'node'
