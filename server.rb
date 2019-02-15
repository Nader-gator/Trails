require 'rack'
require_relative 'app/router'
require_relative 'app/static'

# class Controller < ControllerBase
#   def method
#     #...
#   end
# end

router = Router.new
router.draw do
  # get Regexp.new("^/PATH-HERE$"), ControllerClass, :method
  # get Regexp.new("^/PATH-HERE/(?<id>\\d+)$"), ControllerClass,:method
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)