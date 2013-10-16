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
      end

      def statsd
        @statsd ||= ::Statsd.new(config['statsd']['host']).tap { |sd| sd.namespace = config['statsd']['namespace'] }
      end

      def mysql
        @mysql ||= Mysql2::Client.new config['mysql']
      end

      private

      def instrument_process_list
        show("PROCESSLIST").each do |entry|
          statsd.increment metric("Command", entry)
          statsd.increment metric("State", entry)
        end
      end

      def instrument_statuses
        show("GLOBAL STATUS").each { |entry| statsd.gauge entry["Variable_name"].downcase, entry["Value"] }
      end

      def show(term)
        mysql.query "SHOW #{term}"
      end

      def metric(name, entry)
        "#{name}.#{entry[name].gsub(" ", "_")}".downcase
      end
    end
  end
end
