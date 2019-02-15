require 'active_support/inflector'
require 'erb'
require_relative 'session'

class ControllerBase
  attr_reader :req, :res, :params,:session
  attr_accessor :response_built

  def initialize(req, res)
    @req, @res = req, res
    @response_built = false
  end

  def already_built_response?
    @response_built
  end

  def redirect_response_prep
    raise "Double render error" if self.already_built_response?
    self.response_built = true
    self.session.store_session(@res)

  end

  def redirect_to(url)
    self.redirect_response_prep
    @res.status = 302
    @res["Location"] = url
  end

  def render_content(content, content_type)
      self.redirect_response_prep
      @res.write(content)
      @res['Content-Type'] = content_type

    nil
  end

  def render(template_name)
    path = File.dirname(__FILE__)
    template_path = File.join(path,"..",'views',self.class.name.underscore,"#{template_name}.html.erb")
    template = File.read(template_path)
    render_content(ERB.new(template).result(binding),"text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

end

