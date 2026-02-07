# frozen_string_literal: true

module Api::Helpers
  extend Grape::API::Helpers

  def run_interaction(interaction, inputs = params, success_status: nil)
    outcome = interaction.run(inputs)
    if outcome.valid?
      status(success_status) if success_status
      outcome.result
    else
      error!({ errors: outcome.errors.full_messages }, 400)
    end
  end
end
