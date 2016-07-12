# DX::Grid

The `DX::Grid` module provides methods for converting between lat/long coordinate pairs and amateur radio Maidenhead grid locators. It can also validate the format of a grid string.

The supported grid formats are 4-character (e.g. `FN22`) and 6-character (e.g. `FN32ab`).

The range of grids is from `AA00aa` to `RR99xx`.

You can learn more about grid squares from [the ARRL](http://www.arrl.org/grid-squares).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dx-grid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dx-grid

## Usage

```ruby
require 'dx/grid'
```

### Decoding a Grid to a Coordinate

```ruby
DX::Grid.decode('FN22') # => [42.5, -75.0]
DX::Grid.decode('FN22ab') # => [42.0625, -75.95833333333333]
```

### Encoding a Coordinate to a Grid

```ruby
DX::Grid.encode([42.481076, -75.037847]) # => 'FN22'
DX::Grid.encode([42.481076, -75.037847], :length => 4) # => 'FN22'
DX::Grid.encode([42.481076, -75.037847], :length => 6) # => 'FN22cd'
```

### Validating a Grid

```ruby
DX::Grid.valid?('FN22') # => true
DX::Grid.valid?('fn22') # => true
DX::Grid.valid?('AA00aa') # => true
DX::Grid.valid?('ab12xx') # => true
DX::Grid.valid?('MO00OO') # => true
DX::Grid.valid?('lo00ol') # => true

DX::Grid.valid?('FN') # => false
DX::Grid.valid?('st12') # => false
DX::Grid.valid?('fn22yz') # => false
DX::Grid.valid?('hello world') # => false
DX::Grid.valid?(nil) # => false
DX::Grid.valid?('') # => false
DX::Grid.valid?(5) # => false
DX::Grid.valid?(Math::PI) # => false
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schrockwell/dx-grid.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).