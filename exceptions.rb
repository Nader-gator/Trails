require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    self.app.call(env)
  rescue Exception => e
    self.render_exception
  end
  end

  private

  def render_exception(e)
    path = File.dirname(__FILE__)
    template_fname = File.join(path,"views","default", "rescue.html.erb")
    template = File.read(template_fname)
    body = ERB.new(template).result(binding)

    ['500', {'Content-type' => 'text/html'}, body]
  end

end
