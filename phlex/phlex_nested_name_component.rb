# frozen_string_literal: true

class PhlexNestedNameComponent < Phlex::HTML
  def initialize(name:)
    @name = name
  end

  def view_template
    10.times do
      p(id: "user-#{@name}") { "nested hello #{@name}" }
    end
  end
end
