# GConnect

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'g_connect'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install g_connect

## Usage

**Initialize connection**
```
  g_connect=GConnect::Connexion.new(login,password)
```

**get latest activities**

```
  g_connect.latest_activities(start, limit)
```
  where 'start' is the first activity to get (0 being the most recent), 'limit' is the number of activities.
  Default are 0 and 1 (the most recent activity)

  __Note__: result is a json format, use your preferred parser to read it

**get an activity**
```
 g_connect.activity(activity_id, format)
```
where 'activity_id' is the Garmin activity id and 'format', the format in which you want the result
available format are
*'json' (__Note__: you don't get the track points with this format)
*'tcx' 
*'gpx'

## Contributing

1. Fork it ( https://github.com/[my-github-username]/g_connect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
