class SqspollersController < ApplicationController

  def show

    render plain: stuff().join(', ')

  end

  private
  def stuff( n = -1)

    if n == 0
      return ["slut"]
    end
    #id = ENV['AWS_ACCESS_KEY_ID']
    resp=sqs_instance().receive_message({
                                 queue_url: "https://sqs.eu-west-1.amazonaws.com/691289339601/Magz-Auto-Upload",
                                 wait_time_seconds: 10,
                                 max_number_of_messages: 10
                             })
    recipt=[]
    resp.messages.each do |msg|
      result = DoSomeMagic.call(msg)
      if result.success?
        #delete from queue here
        recipt << msg.receipt_handle
      end
    end


#    sleep(320)


    stuff(resp.messages.count).append(recipt)
  end

  def sqs_instance
     return @sqs ||= Aws::SQS::Client.new(region: 'eu-west-1',credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))
  end

end
