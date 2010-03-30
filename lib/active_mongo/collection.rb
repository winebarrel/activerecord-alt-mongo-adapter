module ActiveMongo
  module Collection
    def self.included(mod)
      mod.instance_eval %{
        primary_key = ActiveRecord::ConnectionAdapters::Column.new('id', nil)
        primary_key.primary = true
        @columns = [primary_key]

        class_eval(<<-EOS)
          @@__with_timestamp = false

          alias :__respond_to? :respond_to?

          def attributes_with_quotes(include_primary_key = true, include_readonly_attributes = true, attribute_names = @attributes.keys)
            quoted = {}
            connection = self.class.connection

            __attributes = (attributes || {}).merge(@__attributes || {})
            __attributes.delete('id')
            __attributes.delete('_id')

            if @@__with_timestamp == :on
              %w(created_at updated_at).each {|i| __attributes.delete(i) }
            elsif @@__with_timestamp
              %w(created_on updated_on).each {|i| __attributes.delete(i) }
            else
              %w(created_on updated_on created_at updated_at).each do |i|
                __attributes.delete(i)
              end
            end

            __attributes.each do |name, value|
              quoted[name] = connection.quote(value)
            end

            quoted
          end

          def respond_to?(name, priv = false); true; end

          def method_missing(name, *args, &block)
            @__attributes ||= {}
            name = name.to_s

            if __respond_to?(name)
              super
            elsif name =~ /\\\\A(.+)=\\\\Z/ and args.length == 1
              @__attributes[$1] = args[0]
            elsif name =~ /[^=]\\\\Z/ and args.length == 0
              @__attributes[$1]
            else
              raise NoMethodError, "undefined method `\\\#{name}' for \#{name}"
              super
            end
          end
        EOS

        def with_timestamp(value = true)
          class_eval(<<-EOS)
            @@__with_timestamp = \#{value}
          EOS
        end
      }
    end
  end
end
