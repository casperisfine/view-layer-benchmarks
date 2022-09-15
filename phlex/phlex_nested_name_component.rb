# frozen_string_literal: true

class PhlexNestedNameComponent < Phlex::Component
  def initialize(name:)
    @name = name
  end

  def template
    10.times do
      p "nested hello #{@name}", id: "user-#{@name}"
    end
  end
end
