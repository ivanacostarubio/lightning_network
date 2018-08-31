class Node


  class Payments
    include Lnd

    def list_invoices
      response = stub.list_invoices(Lnrpc::ListInvoiceRequest.new())
      response.invoices
    end

    def list_payments
      response = stub.list_payments(Lnrpc::ListPaymentRequest.new())
      response.payments
    end



    def decode_pay_req(pay_req)
      stub.decode_pay_req(Lnrpc::PayReqString.new(pay_req: pay_req))
    end

    def lookup_invoice(payment_hash)
      stub.lookup_invoice(Lnrpc::PaymentHash.new(payment_hash))
    end



    def add_invoice(value, memo="")
      stub.add_invoice(Lnrpc::Invoice.new(value: value, memo: memo))
    end

    def send_payment(payment_request)
      r = stub.send_payment_sync(Lnrpc::SendRequest.new(payment_request: payment_request))
    end
  end

  class Channels

    include Lnd


    def open_channel(addr, amt)

      r = addr.split("@")
      pubkey = r[0]
      host = r[1]


      hex = bin_to_hex(pubkey)

      request = Lnrpc::OpenChannelRequest.new(node_pubkey_string: pubkey,
                                              local_funding_amount: amt, 
                                              push_sat: (amt / 100))

      r = stub.open_channel_sync(request)
    end

    def close_channel(channel_point)

      cp = Lnrpc::ChannelPoint.new(funding_txid_str: channel_point)

      stub.close_channel(Lnrpc::CloseChannelRequest.new(channel_point: cp,
                                                        force: true,
                                                        target_conf: 6,
                                                        sat_per_byte: 150000))
    end


    def close_channels
      Node::Payments.new.list_channels["channels"].map do |r|
        puts "Closing #{r["channel_point"]}"
        Node::Payments.new.close_channel( r["channel_point"] )
      end
    end

    def channel_balance
      stub.channel_balance(Lnrpc::ChannelBalanceRequest.new())
    end

    def pending_channels
      stub.pending_channels(Lnrpc::PendingChannelsRequest.new())
    end

    def list_channels
      stub.list_channels(Lnrpc::ListChannelsRequest.new())
    end

    def get_chain_info(chain_id)
      # TODO: ERROR OUT
      stub.get_chain_info(Lnrpc::ChainInfoRequest.new(chain_id: chain_id))
    end

    def get_network_info
      stub.get_network_info(Lnrpc::FeeReportRequest.new())
    end

    def fee_report
      stub.fee_report(Lnrpc::FeeReportRequest.new())
    end

    def update_chan_policy
      # TODO: Raise won't do
      raise "won't do :) "
    end
  end


  include Lnd

  class OnChain
    include Lnd
    def list_chain_txns
      stub.get_transactions(Lnrpc::GetTransactionsRequest.new())
    end

    def send_coins(addr, amt)
      stub.send_coins(Lnrpc::SendCoinsRequest.new(addr: addr, amount: amt))
    end

    def send_many(array_addrs)
      stub.send_many(Lnrpc::SendManyRequest.new(AddrToAmount: array_addrs, target_conf: 6, sat_per_byte:  200))
    end

  end

  class Peers
    include Lnd

    def connect(addr)
      # TODO: Create utility function to separate pub_key and host from full adress
      r = addr.split("@")
      pubkey = r[0]
      host = r[1]

      address = Lnrpc::LightningAddress.new(pubkey: pubkey, host: host)

      stub.connect_peer(Lnrpc::ConnectPeerRequest.new(addr: address, perm: false))
    end
    
    def disconnect(pub_key)
      stub.disconnect_peer(Lnrpc::DisconnectPeerRequest.new(pub_key: pub_key))
    end

    def list_peers
      stub.list_peers(Lnrpc::ListPeersRequest.new())
    end

    def describe_graph
      stub.describe_graph(Lnrpc::ChannelGraphRequest.new())
    end

    def get_node_info(pub_key)
      stub.get_node_info(Lnrpc::NodeInfoRequest.new(pub_key: pub_key))
    end
  end

  class Wallet
    include Lnd

    def new_address
      stub.new_witness_address(Lnrpc::NewWitnessAddressRequest.new())
    end

    def wallet_balance
      stub.wallet_balance(Lnrpc::WalletBalanceRequest.new())
    end

    # TODO: Double check this
    def sign_message(msg)
      stub.sign_message(Lnrpc::SignMessageRequest.new(msg: msg))
    end

    def verify_message(msg, signature)
      stub.verify_message(Lnrpc::VerifyMessageRequest.new(msg: msg, signature: signature))
    end

  end

  def get_info
    stub.get_info(Lnrpc::GetInfoRequest.new())
  end

  def add_invoice(amount)
    response = stub.add_invoice(Lnrpc::Invoice.new(value: amount))
  end

  #
  #
  # We are not using the following methods.
  #
  #

  private

  def balance
    response = stub.wallet_balance(Lnrpc::WalletBalanceRequest.new())
    response.total_balance
  end

end

