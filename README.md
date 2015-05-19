# MySQL::StatsD

Sends data to StatsD from this queries:

    * SHOW GLOBAL STATUS
    * SHOW PROCESSLIST
    * Custom

## Custom Queries

Define them in the config file under mysql.queries . For example:

    mysql:
      ...
      database: app_production
      queries:
        - SELECT count(1) as 'users.count' from users
        - SELECT count(1) as 'premium_users.count' from users where premium = 1

## Installation

    gem install mysql-statsd

Then copy config.yml.sample to a desired path and customize.

## Usage

    mysql-statsd /path/to/config.yml

## Tips

* You may want to configure StatsD to send the gauges as zero when not received:

   ```deleteGauges: true```

* If using Graphite, the derivate function is useful in gauges that only increment over time, for example `threads_running`

## Testing

    rspec spec
