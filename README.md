# MySQL::StatsD

Queries 'SHOW GLOBAL STATUS' and sends the data to StatsD.

## Installation

    gem install mysql-statsd

Then copy config.yml.sample to a desired path and customize

## Usage

    mysql-statsd /path/to/config.yml

## Testing

    rspec spec
