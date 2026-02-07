# frozen_string_literal: true

RSpec::Matchers.define :be_invalid_with do |attribute, error = nil|
  match do |interaction|
    return false if interaction.valid?

    errors = interaction.errors.details[attribute]
    return false if errors.nil?

    if error
      errors.any? { |e| e[:error] == error }
    else
      true
    end
  end

  failure_message do |interaction|
    if interaction.valid?
      "expected interaction to be invalid, but it was valid"
    elsif interaction.errors.details[attribute].nil?
      "expected interaction to have error on :#{attribute}, but got errors: #{interaction.errors.details}"
    else
      "expected interaction to have error :#{error} on :#{attribute}, but got errors: #{interaction.errors.details[attribute]}"
    end
  end
end
