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

          count = parsed_sql[:count]
          distinct = parsed_sql[:distinct]
          selector = query2selector(parsed_sql)
          opts = query2opts(parsed_sql)

          if count and selector.empty? and opts.empty?
            [{count => coll.count}]
          elsif distinct
            coll.distinct(distinct, selector).map do |row|
              {distinct => row}
            end
          else
            rows = []

            coll.find(selector, opts).each do |row|
              row['id'] = row['_id'].to_s if row
              rows << row
            end

            count ? [{count => rows.length}] : rows
          end
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

          coll.update(selector, {'$set' => doc}, :multi => true)
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
        condition = parsed_sql[:condition]
        condition ||= []
        selector = {}

        if is_cond?(condition)
          condition.each do |c|
            name, op, expr, has_not = c.values_at(:name, :op, :expr, :not)
            name = name.split('.').last
            op_expr = nil

            case op
            when '$eq'
              op_expr = expr
            when '$regexp'
              op_expr = Regexp.compile(expr)
            when '$bt'
              op_expr = {'$gte' => expr[0], '$lte' => expr[1]}
            when '$exists'
              op_expr = {'$exists' => !(expr =~ /f|false/i)}
            else
              op_expr = {op => expr}
            end

            if has_not
              if op == '$eq'
                op_expr = {'$ne' => expr}
              elsif op == '$ne'
                op_expr = expr
              else
                op_expr = {'$not' => op_expr}
              end
            end

            if selector[name].kind_of?(Hash) and op_expr.kind_of?(Hash)
              selector[name] = selector[name].merge(op_expr)
            else
              selector[name] = op_expr
            end
          end
        else
          selector['_id'] = {'$in' => [condition].flatten.map {|i| Mongo::ObjectID.from_string(i) }}
        end

        selector
      end

      def query2opts(parsed_sql)
        order, limit, offset = parsed_sql.values_at(:order, :limit, :offset)
        opts = {}

        if order
          name, type = order.values_at(:name, :type)
          opts[:sort] = [name, type]
        end

        if limit
          opts[:limit] = limit.to_i
        end

        if offset
          opts[:skip] = offset.to_i
        end

        opts
      end

      def is_cond?(condition)
        condition.kind_of?(Array) and condition.all? {|i| i.kind_of?(Hash) }
      end
    end
  end
end
