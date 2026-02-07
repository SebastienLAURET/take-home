# frozen_string_literal: true

class Status::Get < ApplicationInteraction
  def execute
    { status: "ok" }
  end
end
