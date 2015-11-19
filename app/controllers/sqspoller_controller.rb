class SqspollerController < ApplicationController

  def create
    sqs = Aws::SQS::Client.new(region: 'eu-west-1',
                              credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))

    # sqs_queue.messages.each do |m|
    #   s3_key = m….
    #       result = DoSomeMagick.call(s3_key)
    #   if result.success?
    #     m.remove_from_queue()
    #   end
    # end
    resp=sqs.receive_message({
                                 queue_url: "https://sqs.eu-west-1.amazonaws.com/691289339601/Magz-Auto-Upload",
                                 wait_time_seconds: 10,
                             })

    resp.messages.each do |msg|
      json = JSON.parse(msg.body)['Message']
      s3_key=JSON.parse(json)['Records'][0]['s3']['object']['key']
      result = DoSomeMagick.call(s3_key)
      if result.success?
        #delete from queue here
        render plain: msg.recieipt_handle
      end
    end


  end


end
