module Fluent
  require 'aws-sdk'

  class SQSPollInput < Input
    Fluent::Plugin.register_input('sqs_poll', self)

    config_param :aws_access_key, :string, :default => nil, :secret => true
    config_param :aws_secret_key, :string, :default => nil, :secret => true
    config_param :tag, :string
    config_param :sqs_url, :string
    config_param :max_number_of_messages, :integer, default: 1

    def configure(conf)
      super
    end

    def start
      super

      @terminate = false
      @thread = Thread.new(&method(:poll))
    end

    def shutdown
      super

      @terminate = true
      @thread.join
    end

    def poll
      region = @sqs_url.split('.')[1]
      Aws.config.update(region: region)

      if @aws_access_key && @aws_secret_key
        Aws.config.update(
          credentials: Aws::Credentials.new(@aws_access_key, @aws_secret_key)
        )
      end

      poller = Aws::SQS::QueuePoller.new(@sqs_url)

      poller.poll(max_number_of_messages: @max_number_of_messages) do |messages|
        throw :stop_polling if @terminate
        messages.each do |msg|
          begin
            Engine.emit(@tag, Time.now.to_i,
              {
                'body' => msg.body,
                'handle' => msg.receipt_handle,
                'id' => msg.message_id,
                'md5' => msg.md5_of_body,
              }
            )
          rescue Exception => e
            $log.error("SQS exception", error: e.to_s, error_class: e.class.to_s)
            $log.warn_backtrace(e.backtrace)
          end
        end
      end
    end
  end
end
