require 'rails_helper'

RSpec.describe Message do
  describe 'validations' do
    it { should define_enum_for(:message_type).with(subject.class.message_types.keys) }
    it { is_expected.to validate_presence_of :payload }

    context "if message_type is send_text" do
      before { allow(subject).to receive(:send_text?).and_return(true) }

      it { is_expected.to validate_length_of(:payload).is_at_most(160) }
    end

    context "if message_type is send_emotion" do
      before { allow(subject).to receive(:send_emotion?).and_return(true) }
      payload_regex = /\A(?:[^\d])*\z/

      it { is_expected.to validate_length_of(:payload).is_at_least(2).is_at_most(10) }

      it 'is invalid when format regex does not have matches' do
        invalid_payloads = %w[2aa aa2 a2a a22 22a a22a aa22 22aa aa22aa 2222 2]
        invalid_payloads.each do |invalid_payload|
          subject.payload = invalid_payload

          expect(subject.payload).not_to match payload_regex
          expect(subject).not_to be_valid
          expect(subject.errors[:payload]).to be_present
        end
      end

      it 'is valid when format regex has matches' do
        valid_payloads = %w[aa a-a a*a &@ %&* _a -a]
        valid_payloads.each do |valid_payload|
          subject.payload = valid_payload

          expect(subject.payload).to match payload_regex
          expect(subject).to be_valid
          expect(subject.errors[:payload]).to be_empty
        end
      end
    end
  end
end
