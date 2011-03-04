require 'spec_helper.rb'

describe Paypal::Exception::APIError do
  let(:error) { Paypal::Exception::APIError.new(params) }

  context 'when Hash is given' do
    let :params do
      {
        :VERSION=>"66.0",
        :TIMESTAMP=>"2011-03-03T06:33:51Z",
        :CORRELATIONID=>"758ebdc546b9c",
        :L_SEVERITYCODE0=>"Error",
        :L_ERRORCODE0=>"10411",
        :L_LONGMESSAGE0=>"This Express Checkout session has expired.  Token value is no longer valid.",
        :BUILD=>"1741654",
        :ACK=>"Failure",
        :L_SHORTMESSAGE0=>"This Express Checkout session has expired."
      }
    end

    describe '#subject' do
      subject { error.response }
      its(:raw) { should == params }
      Paypal::Exception::APIError::Response.attribute_mapping.each do |key, attribute|
        its(attribute) { should == params[key] }
      end

      describe '#details' do
        subject { error.response.details.first }
        Paypal::Exception::APIError::Response::Detail.attribute_mapping.each do |key, attribute|
          its(attribute) { should == params[:"L_#{key}0"] }
        end
      end
    end
  end

  context 'when unknown params given' do
    let :params do
      {
        :UNKNOWN => 'Unknown',
        :L_UNKNOWN0 => 'Unknown Detail'
      }
    end

    it 'should warn' do
      Paypal.logger.should_receive(:warn).with(
        "Ignored Parameter (Paypal::Exception::APIError::Response): UNKNOWN=Unknown"
      )
      Paypal.logger.should_receive(:warn).with(
        "Ignored Parameter (Paypal::Exception::APIError::Response::Detail): UNKNOWN=Unknown Detail"
      )
      error
    end
    describe '#response' do
      subject { error.response }
      its(:raw) { should == params }
    end
  end

  context 'otherwise' do
    subject { error }
    let(:params) { 'Failure' }
    its(:response) { should == params }
  end
end