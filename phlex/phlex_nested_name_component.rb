# frozen_string_literal: true

class PhlexNestedNameComponent < Phlex::HTML
  def initialize(name:)
    @name = name
  end

  def view_template
    3.times do
      div(class: "users") do
        h2 { "#{@name} message" }
        p(id: "user-#{@name}") do
          span(class: "title") { "they:" }
          span(class: "message") { "nested hello #{@name}" }
        end
      end
    end
  end
end
