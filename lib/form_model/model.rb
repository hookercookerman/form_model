require "active_model"
require "virtus"
require "active_support/concern"
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/keys'

module FormModel
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    include Virtus
    class_attribute :after_read_block
    class_attribute :before_write_block
    class_attribute :bound_block
    class_attribute :mappers
    self.mappers = []

    attr_accessor :data_model
    alias :model= :data_model=
    alias :model :data_model

    def initialize(model = bound_class.new, attributes = nil)
      if model.is_a?(Hash)
        super(model)
      else
        super(attributes)
        @data_model = model 
        assert_correct_model
        apply_mappers_to_form!
      end
    end
  end

  def valid?(type = :model_and_form, context = nil)
    return super(context) if type == :form
    update_data_model!
    ok = (super(context) and data_model.valid?(context))
    merge_data_model_errors! unless ok
    ok
  end

  def merge_errors_with!(object)
    object.errors.to_hash.each do |key, value|
      self.errors.add(key, value)
    end
  end

  def bound_class
    self.class.bound_class
  end

  def save(options = {})
    valid?(options) ? data_model.save(options) : false
  end

  def form_valid?
    valid?(:form)
  end

  def update(attrs = {})
    self.attributes = attrs || {}
    self
  end

  def persisted?
    data_model.persisted?
  end

  def to_model
    data_model.to_model
  end

  def to_key
    data_model.to_key
  end

  def to_param
    data_model.to_param
  end

  def to_path
    data_model.to_path
  end

  def update_data_model!
    if data_model
      attrs = attributes.slice(*data_model_attribute_names).stringify_keys
      apply_mappers_to_model!(attrs)
      self.instance_exec(&before_write_block) unless self.class.before_write_block.nil?
      data_model.write_attributes(attrs)
      data_model
    end
  end

  def respond_to?(method_sym, include_private = false)
    super || data_model.respond_to?(method_sym, include_private)
  end

  module ClassMethods
    def validates_associated(*args)
      validates_with(FormModel::AssociatedValidator, _merge_attributes(args))
    end

    def bind_to(&block)
      self.bound_block = block
    end

    def mapper(mapper_class, options = {})
      mappers << mapper_class.new(options)
    end

    def after_read &block
      self.after_read_block = block
    end

    def before_write &block
      self.before_write_block = block
    end

    def bound_class
      @bound_class ||= self.bound_block.call
    end

    def form_attributes
      self.attribute_set.map{|attr| attr.name.to_s}
    end

    def load(data_model)
      data_model_attributes = data_model.attributes
      attrs = data_model_attributes.slice(*form_attributes)
      self.new(data_model, attrs).tap do |instance|
        instance.instance_exec(&after_read_block) unless after_read_block.nil?
      end
    end
  end

  private
  def merge_data_model_errors!
    data_model.errors.to_hash.each do |key, value|
      self.errors.add(key, value)
    end
  end

  def assert_correct_model
    if !data_model.is_a?(bound_class)
      raise ModelMisMatchError.new("Tried to use object of class #{data_model.class.name} only #{bound_class.name} allowed")
    end
  end

  def apply_mappers_to_form!
    mappers.each do |mapper|
      self.attributes = self.attributes.merge(mapper.to_form(data_model))
    end
  end

  def apply_mappers_to_model!(attrs)
    mappers.each do |mapper|
      attrs.merge!(mapper.to_model(self))
    end
  end

  def method_missing(method, *args, &block)
    data_model.send(method, *args, &block)
  end

  def data_model_attribute_names
    data_model.fields.keys.map(&:to_sym) + data_model.relations.keys.map(&:to_sym)
  end
end
