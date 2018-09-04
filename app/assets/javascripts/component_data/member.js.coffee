@MemberData = flight.component ->
  @after 'initialize', ->
    return if not gon.user
    channel = @attr.pusher.subscribe("private-#{gon.user.sn}")

    console.log('Private Channel connected successfully')

    channel.bind 'account', (data) =>
      gon.accounts[data.currency.code] = data
      @trigger 'account::update', gon.accounts

    channel.bind 'order', (data) =>
      @trigger "order::#{data.state}", data

    channel.bind 'trade', (data) =>
      @trigger 'trade', data

    # Initializing at bootstrap
    @trigger 'account::update', gon.accounts
    @trigger 'order::wait::populate', orders: gon.my_orders if gon.my_orders
    @trigger 'trade::populate', trades: gon.my_trades if gon.my_trades
