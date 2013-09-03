require "mysql-statsd/version"
require 'yaml'
require 'mysql2'
require 'statsd-ruby'

module Mysql
  module Statsd
    class << self
      def run
        statuses.each do |status|
          statsd.gauge status["Variable_name"].downcase, status["Value"]
        end
      end

      private

      def config
        @config ||= YAML.load_file 'config.yml'
      end

      def statsd
        @statsd ||= ::Statsd.new config['statsd']['host']
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
