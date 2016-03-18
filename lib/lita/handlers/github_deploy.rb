require 'octokit'

module Lita
  module Handlers
    class GitHubDeploy < Handler
      namespace :github_deploy
      config :access_token, type: String, required: true
      config :apps, type: Hash, required: true

      route(/^deploy\s+/, :deploy, command: true, help: {
        'deploy APP' => 'Deploy APP.',
        'deploy APP#REF' => 'Deploy REF.',
        'deploy APP to ENV' => 'Deploy to ENV'
      })

      def deploy(response)
        app, _, env = response.args
        app, ref = app.split('#')
        app_config = config.apps[app]
        if app_config
          repo = app_config.fetch(:repo)
          ref ||= app_config.fetch(:default_ref, 'master')
          env ||= app_config.fetch(:default_env, 'production')
          payload = build_payload(app_config)
          create_deployment(repo, ref, env, payload)
          response.reply("deploying #{repo}##{ref} to #{env}")
        else
          response.reply("#{app} not found")
        end
      end

      private

      def create_deployment(repo, ref, env, payload)
        client = Octokit::Client.new(access_token: config.access_token)
        client.create_deployment(repo, ref, environment: env, payload: payload)
      end

      def build_payload(app_config)
        app_config.select { |k, _| k != :repo }
      end

      Lita.register_handler(self)
    end
  end
end
