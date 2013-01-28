# encoding: utf-8
module FormModel
  class AssociatedValidator < ActiveModel::EachValidator

    # Validates that the associations provided are either all nil or all
    # valid. If neither is true then the appropriate errors will be added to
    # the parent document.
    #
    # @example Validate the association.
    #   validator.validate_each(document, :name, name)
    #
    # @param [ Document ] document The document to validate.
    # @param [ Symbol ] attribute The relation to validate.
    # @param [ Object ] value The value of the relation.
    def validate_each(form, attribute, value)
      begin
        valid = Array.wrap(value).collect do |doc|
          if doc.nil?
            true
          else
            doc.valid?
          end
        end.all?
      end
      form.errors.add(attribute, :invalid, options) unless valid
    end
  end
end

