# MySQL::StatsD

Sends data to StatsD from this queries:

    * SHOW GLOBAL STATUS
    * SHOW PROCESSLIST

## Installation

    gem install mysql-statsd

Then copy config.yml.sample to a desired path and customize.

## Usage

    mysql-statsd /path/to/config.yml

## Tips

* You may want to configure StatsD to send the gauges as zero when not received:

    deleteGauges: true

* If using Graphite, the derivate function is useful in gauges that only increment over time, for example threads_running

## Testing

    rspec spec
