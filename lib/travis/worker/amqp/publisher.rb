require 'hot_bunnies'
require 'multi_json'
require 'hashr'

module Travis
  module Worker
    module Amqp
      class Publisher
        class << self
          def commands
            new('worker.commands')
          end

          def reporting
            new('reporting.jobs')
          end
        end

        attr_reader :routing_key, :options

        def initialize(routing_key, options = {})
          @routing_key = routing_key
          @options = options
        end

        def publish(data, options = {})
          data = MultiJson.encode(data) if data.is_a?(Hash)
          options = options.merge(:routing_key => routing_key)
          exchange.publish(data, options)
        end

        protected

          def exchange
            @exchange ||= channel.default_exchange
          end

          def channel
            @channel ||= Amqp.connection.create_channel # TODO set prefetch?
          end
      end
    end
  end
end
