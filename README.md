# lita-github-deploy

[![Build Status](https://travis-ci.org/lest/lita-github-deploy.svg?branch=master)](https://travis-ci.org/lest/lita-github-deploy)
[![Coverage Status](https://coveralls.io/repos/lest/lita-github-deploy/badge.svg)](https://coveralls.io/r/lest/lita-github-deploy)

[GitHub Flow][1] via [Lita][2].

## Installation

Add `lita-github-deploy` to your Lita instance's Gemfile:

``` ruby
gem 'lita-github-deploy'
```

## Configuration

``` ruby
Lita.configure do |config|
  config.handlers.github_deploy.access_token = 'myaccesstoken'
  config.handlers.github_deploy.apps = {'myapp' => {repo: 'testuser/myapp'}}
end
```

## Usage

```
Lita: deploy myapp
Lita: deploy myapp#mybranch to staging
```

[1]: https://guides.github.com/overviews/flow/
[2]: https://www.lita.io
