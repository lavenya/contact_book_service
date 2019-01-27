# frozen_string_literal: true

class Error
  attr_accessor :object_error, :error_messages
  def initialize(object_error)
    @object_error = object_error
    @error_messages = []
  end

  def messages
    @object_error.each do |key, message|
      @error_messages.push(key.to_s + ' ' +  message)
    end
    @error_messages
  end
end
