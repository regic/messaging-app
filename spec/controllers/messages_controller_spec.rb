require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:some_message) { double('some message') }
  let(:other_message) { double('other message') }

  describe 'GET #index' do
    it 'renders the :index template' do
      get :index

      expect(response).to render_template :index
    end

    it 'assigns @messages' do
      allow(Message).to receive_message_chain(:all, :select).and_return([some_message, other_message])

      get :index

      expect(assigns(:messages)).to match [some_message, other_message]
    end
  end

  describe 'POST #create' do
    it 'throws ActionController::UrlGenerationError error if type parameter is invalid' do
      expect { post :create, params: { type: :invalid } }.to raise_error ActionController::UrlGenerationError
    end

    context 'with invalid params' do
      it 'returns status code 412 with blank page' do
        invalid_parameters = [
          { type: :send_emotion, message: { invalid: :params } },
          { type: :send_emotion, message: { payload: '' } },
          { type: :send_emotion, message: { payload: 'a' } },
          { type: :send_emotion, message: { payload: 'a7' } },
          { type: :send_emotion, message: { payload: '77' } },
          { type: :send_emotion, message: { payload: 'a' * 11 } },
          { type: :send_text, message: { payload: 'a' * 161 } }
        ]

        invalid_parameters.each do |invalid_params|
          post :create, params: invalid_params

          expect(response.response_code).to eq 412
          expect(response.body).to be_blank
        end
      end
    end

    context 'with valid params' do
      it 'creates a new Message and returns 201 code with blank page' do
        new_message = double.as_null_object

        allow(Message).to receive(:new).
                           with('message_type' => 'send_emotion', 'payload' => 'something').
                           and_return(new_message)
        allow(new_message).to receive(:save).and_return true

        post :create, params: { type: :send_emotion, message: { payload: 'something' } }

        expect(response.response_code).to eq 201
        expect(response.body).to be_blank
      end
    end
  end
end
