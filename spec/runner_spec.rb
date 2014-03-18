require 'mysql-statsd'

describe Mysql::Statsd::Runner do
  let(:config_path) { "spec/config.yml" }
  subject { Mysql::Statsd::Runner.new config_path }

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

  describe "#run!" do
    before :each do
      subject.mysql.stub(:query).and_return []
    end

    it "should query the global status" do
      subject.mysql.should_receive(:query).with("SHOW GLOBAL STATUS").and_return [{'Variable_name' => 'Fake', 'Value' => 1}]
      subject.run!
    end

    it "should instrument the process list" do
      subject.mysql.stub(:query).with("SHOW PROCESSLIST").and_return [{'Command' => 'Jump', 'State' => 'Long Lived'}, {'Command' => 'Jump', 'State' => 'Long Dead'}]
      subject.statsd.should_receive(:gauge).with('state.long_lived', 1)
      subject.statsd.should_receive(:gauge).with('state.long_dead', 1)
      subject.statsd.should_receive(:gauge).with('command.jump', 2)
      subject.run!
    end

    it "should query configured queries" do
      subject.mysql.stub(:query).with("SELECT count(1) as 'users.count' from users").and_return [{'users.count' => 15}]
      subject.statsd.should_receive(:gauge).with('users.count', 15)
      subject.run!
    end

    context "with a config file without queries" do
      let(:config_path) { "spec/config_without_queries.yml" }

      it "should not break" do
        lambda { subject.run! }.should_not raise_exception
      end
    end
  end
end
