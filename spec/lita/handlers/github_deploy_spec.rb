require 'spec_helper'

RSpec.describe Lita::Handlers::GitHubDeploy, lita_handler: true do
  before do
    allow(robot.config.handlers.github_deploy).to receive_messages(
      apps: {'myapp' => app_config},
      access_token: 'myaccesstoken'
    )
  end

  let(:app_config) { {repo: 'testuser/myapp'} }

  shared_examples 'deploy' do
    it 'sends create deployment request' do
      stub_request(:post, 'https://api.github.com/repos/testuser/myapp/deployments')
        .with(body: params,
              headers: {'Authorization' => 'token myaccesstoken'})

      send_command(command)

      expect(replies.last).to eq(reply)
    end
  end

  context 'deploy app' do
    let(:command) { 'deploy myapp' }
    let(:params) { {environment: 'production', ref: 'master', payload: {}} }
    let(:reply) { 'deploying testuser/myapp#master to production' }
    include_examples 'deploy'
  end

  context 'deploy app to staging' do
    let(:command) { 'deploy myapp to staging' }
    let(:params) { {environment: 'staging', ref: 'master', payload: {}} }
    let(:reply) { 'deploying testuser/myapp#master to staging' }
    include_examples 'deploy'
  end

  context 'deploy app#ref' do
    let(:command) { 'deploy myapp#experiment' }
    let(:params) { {environment: 'production', ref: 'experiment', payload: {}} }
    let(:reply) { 'deploying testuser/myapp#experiment to production' }
    include_examples 'deploy'
  end

  context 'when app is not found' do
    subject { replies.last }
    before { send_command('deploy foobar') }

    it { is_expected.to eq('foobar not found') }
  end

  context 'with custom payload' do
    before { app_config[:deploy_script] = 'script/deploy' }

    let(:command) { 'deploy myapp' }
    let(:params) { {environment: 'production', ref: 'master', payload: {deploy_script: 'script/deploy'}} }
    let(:reply) { 'deploying testuser/myapp#master to production' }
    include_examples 'deploy'
  end
end
