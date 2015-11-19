class SqspollersController < ApplicationController

  def show
    stuff

  end

  private
    def stuff
      id = ENV['AWS_ACCESS_KEY_ID']
      sqs = Aws::SQS::Client.new(region: 'eu-west-1',
                                credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))

      resp=sqs.receive_message({
                                   queue_url: "https://sqs.eu-west-1.amazonaws.com/691289339601/Magz-Auto-Upload",
                                   wait_time_seconds: 20,
                                   max_number_of_messages: 10
                               })
      recipt=[]
      resp.messages.each do |msg|
        json = JSON.parse(msg.body)['Message']
        s3_key=JSON.parse(json)['Records'][0]['s3']['object']['key']
        result = DoSomeMagic.call(msg)
        if result.success?
          #delete from queue here
          recipt << msg.receipt_handle
        end
      end

      render plain: recipt.join(',\n ')
  end


end
