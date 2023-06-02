require 'stripe'

Rails.configuration.stripe = {
    :publishable_key => 'pk_test_51NDMtBAeTI5PSxdnBqURjnL0S9fmATINWyRf6Jg9MdxHt59iTZMpHeePP2aRPLmeCO1L3z3gzwigkDOLJAfby6DO00jhGfb37b',
    :secret_key => 'sk_test_51NDMtBAeTI5PSxdnoxMQUUPq8hrvd2Uk1fuAeVb8V0NUnwSTRCHLrm9UsA4GVusiwWgu6fLyFj7IWJ8rT9OqP1Ie00PSt570Xf'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
