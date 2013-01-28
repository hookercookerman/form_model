module FormModel
  class Error < StandardError; end
  class ModelMisMatchError < Error; end
  class MapperAssertionError < Error; end
end
