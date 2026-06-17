require "ransack"
require "mobility"
require "mobility/ransack"

module Mobility
  module Plugins
    module Ransack
      extend Plugin

      default true
      requires :backend, include: :before
      requires :active_record

      # Applies ransack plugin.
      # @param [Attributes] attributes
      # @param [Boolean] option
      included_hook do |klass, backend_class|
        if options[:ransack]
          names.each do |name|
            klass.ransacker(name) { backend_class.build_node(name, Mobility.locale) }
          end

          locales = options[:ransack] == true ? Mobility.available_locales : Array(options[:ransack])
          locales.each do |locale|
            locale = locale.to_sym
            normalized = Mobility.normalize_locale(locale)
            names.each do |name|
              klass.ransacker("#{name}_#{normalized}") { backend_class.build_node(name, locale) }
            end
          end
        end
      end
    end

    register_plugin(:ransack, Ransack)
  end
end
