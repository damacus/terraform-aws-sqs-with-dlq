require 'awspec'
require 'aws-sdk'
require 'rhcl'

describe sqs('test-queue'), region: 'eu-west-1' do
  it { should exist }
  its(:visibility_timeout) { should eq '30' }
end

describe sqs('test-queue-dead-letter-queue'), region: 'eu-west-1' do
  it { should exist }
end

describe cloudwatch_alarm('test-queue-flood-alarm'), region: 'eu-west-1' do
  it { should exist }
end

describe cloudwatch_alarm('test-queue-dead-letter-queue-not-empty-alarm'), region: 'eu-west-1' do
  it { should exist }
end
