module ResponseHelper
  def hash_response
    JSON.parse(response.body).deep_symbolize_keys!
  end
end