class SqspollerController < ApplicationController

  def create
    sqs = Aws::SQS::Client.new(region: 'us-east-1'

    )

  end


end
