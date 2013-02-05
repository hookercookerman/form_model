require "active_support/concern"
require "active_model/validations"

module FormModel
  module Mapper
    extend  ActiveSupport::Concern
    include ActiveModel::Validations

    included do
      class_attribute :_form_keys
      class_attribute :_model_keys
      self._form_keys = []
      self._model_keys = []

      attr_accessor :_form_keys_values
      attr_accessor :_model_keys_values

      def initialize(options = {})
        extract_options!(options)
      end
    end

    module ClassMethods
      def form_keys(*keys)
        self._form_keys += keys
      end

      def model_keys(*keys)
        self._model_keys += keys
      end
    end

    def assert_model_values(model, *values, &block)
      hash = Array(values).inject({}) do |var, key|
        value = model_value(model, key)
        raise FormModel::MapperAssertionError if value.nil?
        var[key] = value
        var
      end
      block.call(hash)
    rescue FormModel::MapperAssertionError
      {}
    end

    def assert_form_values(form, *values, &block)
      hash = Array(values).inject({}) do |var, key|
        value = form_value(form, key)
        raise FormModel::MapperAssertionError if value.nil?
        var[key] = value
        var
      end
      block.call(hash)
    rescue FormModel::MapperAssertionError
      {}
    end

    def form_keys
      self.class._form_keys
    end

    def model_keys
      self.class._model_keys
    end

    def form_value(form, key)
      if value_key = _form_keys_values[key]
        value_key.respond_to?(:call) ? value_key.call(form) : form.send(value_key)
      end
    end

    def form_attribute(key)
      _form_keys_values[key].to_s
    end

    def model_value(model, key)
      if value_key = _model_keys_values[key]
        value_key.respond_to?(:call) ? value_key.call(model) : model.send(value_key)
      end
    end

    def model_attribute(key)
      _model_keys_values[key].to_s
    end

    def to_form(attributes)
      {}
    end

    def to_model(attribute)
      {}
    end

    private
    def extract_options!(options)
      form_options = options[:form] || options[:model] || {}
      model_options = options[:model] || options[:form] || {}
      extract_form_options!(form_options)
      extract_model_options!(model_options)
      check_have_all_values
    end

    def check_have_all_values
      true
    end

    def extract_form_options!(options)
      raise Exception.new("All Form Options were Not Given") unless options.keys.all?{|key| _form_keys.include?(key)}
      @_form_keys_values = options
    end

    def extract_model_options!(options)
      raise Exception.new("All Model Options were Not Given") unless options.keys.all?{|key| _model_keys.include?(key)}
      @_model_keys_values = options
    end

  end
end
