# frozen_string_literal: true

module JsonHelper
  def json_parse
    JSON.parse(response.body)
  end
end
