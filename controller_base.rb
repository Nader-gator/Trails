
class ControllerBase
  attr_reader :req, :res, :params
  attr_accessor :response_built

  def initialize(req, res)
    @req, @res = req, res
    @response_built = false
  end

  def already_built_response?
    @response_built
  end

  def redirect_to(url)
    @res.status = 302
    @res["Location"] = url
  end

  def render_content(content, content_type)
      raise "Double render error" if self.already_built_response?
      @res.write(content)
      @res['Content-Type'] = content_type
      self.response_built = true

    nil
  end

end

