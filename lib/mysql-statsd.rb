require "mysql-statsd/version"
require 'yaml'
require 'mysql2'
require 'statsd-ruby'

module Mysql
  module Statsd
    class Runner
      attr_reader :config

      def initialize(config_path)
        @config ||= YAML.load_file config_path
      end

      def run!
        instrument_statuses
        instrument_process_list
        instrument_queries
      end

      def statsd
        @statsd ||= ::Statsd.new(config['statsd']['host']).tap { |sd| sd.namespace = config['statsd']['namespace'] }
      end

      def mysql
        @mysql ||= Mysql2::Client.new config['mysql']
      end

      private

      def instrument_process_list
        @process_list = show "PROCESSLIST"
        instrument_processes "State"
        instrument_processes "Command"
      end

      def instrument_statuses
        show("GLOBAL STATUS").each { |entry| statsd.gauge entry["Variable_name"].downcase, entry["Value"] }
      end

      def instrument_queries
        config['mysql']['queries'].map { |query| mysql.query(query).first }.compact.each do |entry|
          statsd.gauge *entry.to_a.flatten
        end
      end

      def show(term)
        mysql.query "SHOW #{term}"
      end

      def instrument_processes(metric_name)
        @process_list.map { |row| row[metric_name] }.group_by(&:to_s).each { |metric, values| statsd.gauge "#{metric_name}.#{metric.gsub(" ", "_")}".downcase, values.count }
      end
    end
  end
end
