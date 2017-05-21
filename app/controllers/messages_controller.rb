class MessagesController < ApplicationController
  def index
    @messages = Message.select(:payload)
  end

  def create
    head Message.new(message_params).save ? 201 : 412
  end

  private

    def message_params
      params.require(:message).permit(:payload).merge(message_type: params[:type])
    end
end
