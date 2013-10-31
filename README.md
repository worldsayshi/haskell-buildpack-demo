A simple hello world Happstack Lite example that should be deploy-able on Heroku. 

It is also using Clay for generating css on request.

Adapted from https://github.com/puffnfresh/haskell-buildpack-demo

How to deploy:

    heroku create --stack=cedar --buildpack https://github.com/pufuwozu/heroku-buildpack-haskell.git
    git push heroku master