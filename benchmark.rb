#!/usr/bin/env ruby
# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "rack/test"
require "action_controller/railtie"
require "benchmark/ips"

# Configure Rails Environment
ENV["RAILS_ENV"] = "production"

class TestApp < Rails::Application
  config.root = __dir__
  config.hosts << "example.org"
  config.session_store :cookie_store, key: "cookie_store_key"
  config.secret_key_base = "secret_key_base"

  config.logger = Logger.new(nil)
  config.logger.level = Logger::INFO
  Rails.logger  = config.logger
end

# class Cell::ViewModel
#   self.view_paths = ["cells"]
# end

require "phlex-rails"
require_relative "./components/name_component"
require_relative "./components/nested_name_component"

# require_relative "./cells/name/cell"
# require_relative "./cells/nested_name/cell"
#
# require_relative "./dry-views/name/view"
# require_relative "./dry-views/nested_name/view"

require_relative "./phlex/phlex_name_component"
require_relative "./phlex/phlex_nested_name_component"

class BenchmarksController < ActionController::Base
end

BenchmarksController.view_paths = ["./partials"]
controller_view = BenchmarksController.new.view_context

class NameObj
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_partial_path
    "name"
  end
end

puts "Rendering #{PhlexNameComponent.new(name: "Fox Mulder").call.bytesize} bytes (Phlex)"
puts "Rendering #{controller_view.render("/name", name: "Fox Mulder").bytesize} bytes (Partials)"

Benchmark.ips do |x|
  x.report("partials") { controller_view.render("/name", name: "Fox Mulder #{rand}") }
  x.report("phlex") { controller_view.render(PhlexNameComponent.new(name: "Fox Mulder #{rand}")) }
  # x.report("view_component") { controller_view.render(NameComponent.new(name: "Fox Mulder #{rand}")) }
  # x.report("cells") { controller_view.render(html: Name::Cell.new(NameObj.new("Fox Mulder #{rand}")).()) }
  # x.report("dry_view") { controller_view.render(html: Name::View.new.call(name: "Fox Mulder #{rand}").to_s)  }

  x.compare!(order: :baseline)
end
