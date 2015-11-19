class DoSomeMagic

  Result = Struct.new(:success?)

  def self.call(*args)
    new(*args).call
  end

  def initialize(s3_key)
    @s3_key = s3_key
  end

  def call
    return Result.new(true)
  end

private

  attr_reader :s3_key

end
