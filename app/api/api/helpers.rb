# frozen_string_literal: true

module Api::Helpers
  extend Grape::API::Helpers

  def run_interaction(interaction, inputs = params)
    outcome = interaction.run(inputs)
    if outcome.valid?
      outcome.result
    else
      error!({ errors: outcome.errors.full_messages }, 422)
    end
  end
end
