require 'lino'
require_relative 'base'
require_relative 'mixins/environment'

module RubyFly
  module Commands
    class DestroyPipeline < Base
      include Mixins::Environment

      def configure_command(builder, opts)
        builder = super(builder, opts)

        missing_params = [
            :target,
            :pipeline
        ].select { |param| opts[param].nil? }

        unless missing_params.empty?
          description = missing_params.map { |p| "'#{p}'" }.join(', ')
          raise(
              ArgumentError,
              "Error: #{description} required but not provided.")
        end

        target = opts[:target]
        pipeline = opts[:pipeline]
        non_interactive = opts[:non_interactive]
        team = opts[:team]

        builder
            .with_subcommand('destroy-pipeline') do |sub|
              sub = sub.with_option('-t', target)
              sub = sub.with_option('-p', pipeline)
              sub = sub.with_option('--team', team) if team
              sub = sub.with_flag('-n') if non_interactive
              sub
            end
      end
    end
  end
end