# MySQL::StatsD

Sends data to StatsD from this queries:

    * SHOW GLOBAL STATUS
    * SHOW PROCESSLIST

## Installation

    gem install mysql-statsd

Then copy config.yml.sample to a desired path and customize.

## Usage

    mysql-statsd /path/to/config.yml

## Testing

    rspec spec
