require 'mysql-statsd'

describe Mysql::Statsd::Runner do
  subject { Mysql::Statsd::Runner.new "spec/config.yml" }

  before :each do
    Mysql2::Client.any_instance.stub :connect
  end

  it "should set the statsd namespace as mysql" do
    subject.statsd.namespace.should == 'ns'
  end

  it "should set the statds host from the config file" do
    subject.statsd.host.should == 'statsdhost'
  end

  it "should set the mysql host from the config file" do
    subject.mysql.query_options[:host].should == 'mysqlhost'
  end

  it "should set the mysql user from the config file" do
    subject.mysql.query_options[:username].should == 'user'
  end
end
