require 'active_record/base'
require 'active_record/connection_adapters/abstract_adapter'
require 'mongo'
require 'active_mongo/collection'
require 'active_mongo/sqlparser.tab'

module ActiveRecord
  class Base
    def self.mongo_connection(config)
      config = config.symbolize_keys
      pair_or_host = config[:host] || 'localhost'
      port = config[:port] || 27017
      database = config[:database]

      options = config.dup
      [:adapter, :host, :port, :database].each {|i| options.delete(i) }

      connection = Mongo::Connection.new(pair_or_host, port, options).db(database)
      ConnectionAdapters::MongoAdapter.new(connection, logger, config)
    end
  end

  module ConnectionAdapters
    class MongoAdapter < AbstractAdapter
      def initialize(connection, logger, config)
        super(connection, logger)
        @config = config
      end

      def supports_count_distinct?
        false
      end

      def select(sql, name = nil)
        log(sql, name) do
          parsed_sql = ActiveMongo::SQLParser.new(sql).parse
          table = parsed_sql[:table]
          coll = @connection.collection(table)
          rows = []

          if (count = parsed_sql[:count])
            rows << {count => coll.count}
          else
            selector = query2selector(parsed_sql)

            coll.find(selector).each do |row|
              row['id'] = row['_id'].to_s if row
              rows << row
            end
          end

          rows
        end
      end

      def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil)
        log(sql, name) do
          parsed_sql = ActiveMongo::SQLParser.new(sql).parse
          table, column_list, value_list = parsed_sql.values_at(:table, :column_list, :value_list)

          doc = {}
          column_list.zip(value_list).each {|k, v| doc[k] = v }

          coll = @connection.collection(table)
          coll.insert(doc).to_s
        end
      end

      def update_sql(sql, name = nil)
        log(sql, name) do
          parsed_sql = ActiveMongo::SQLParser.new(sql).parse
          table = parsed_sql[:table]
          coll = @connection.collection(table)
          selector = query2selector(parsed_sql)
          set_clause_list = parsed_sql[:set_clause_list]
          doc = {}

          set_clause_list.each do |k, v|
            k = k.split('.').last
            doc[k] = v
          end

          coll.update(selector, {'$set' => doc})
        end

        # XXX:
        1
      end

      def delete_sql(sql, name = nil)
        log(sql, name) do
          parsed_sql = ActiveMongo::SQLParser.new(sql).parse
          table = parsed_sql[:table]
          coll = @connection.collection(table)
          selector = query2selector(parsed_sql)
          coll.remove(selector)
        end

        # XXX:
        1
      end

      private
      def query2selector(parsed_sql)
        condition, order, limit = parsed_sql.values_at(:condition, :order, :limit)
        condition ||= []
        selector = {}

        if is_cond?(condition)
          condition.each do |c|
            name, op, expr = c.values_at(:name, :op, :expr)
            name = name.split('.').last

            case op
            when '$eq'
              selector[name] = expr
            when '$regexp'
              selector[name] = Regexp.compile(expr)
            else
              selector[name] = {op => expr}
            end
          end
        else
          selector['_id'] = {'$in' => [condition].flatten.map {|i| Mongo::ObjectID.from_string(i) }}
        end

        selector
      end

      def is_cond?(condition)
        condition.kind_of?(Array) and condition.all? {|i| i.kind_of?(Hash) }
      end
    end
  end
end
