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
        statuses.each do |status|
          statsd.gauge status["Variable_name"].downcase, status["Value"]
        end

        process_list.each do |process|
          statsd.increment status["Command"].downcase
        end
      end

      def statsd
        @statsd ||= ::Statsd.new(config['statsd']['host']).tap { |sd| sd.namespace = config['statsd']['namespace'] }
      end

      def mysql
        @mysql ||= Mysql2::Client.new config['mysql']
      end

      private

      def statuses
        mysql.query "SHOW GLOBAL STATUS"
      end

      def process_list
        mysql.query "SHOW PROCESSLIST"
      end
    end
  end
end
