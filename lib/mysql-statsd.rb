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
      end

      private

      def statsd
        @statsd ||= ::Statsd.new(config['statsd']['host']).tap { |sd| sd.namespace = 'mysql' }
      end

      def statuses
        client.query "SHOW GLOBAL STATUS"
      end

      def client
        @client ||= ::Mysql2::Client.new config['mysql']
      end
    end
  end
end
