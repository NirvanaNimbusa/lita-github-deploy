Lita.configure do |config|
  config.handlers.github_deploy.access_token = 'myaccesstoken'
  config.handlers.github_deploy.apps = {'myapp' => {repo: 'testuser/myapp'}}
end
