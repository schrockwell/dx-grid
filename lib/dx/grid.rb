require "dx/grid/version"

module DX
  module Grid
    def self.encode(coord, options={})
      length = options[:length] || 4
      validate_grid_length!(length)
      validate_coord!(coord)

      lat, lon = coord[0], coord[1]
      grid = ''

      # Normalize from (-90, -180) to (0, 0)
      lon = lon + 180.0
      lat = lat + 90.0

      # Map lon from 0 to 17 (A to R)
      lon_index = (lon / 20.0).to_i
      lat_index = (lat / 10.0).to_i

      # Convert to characters
      grid += "#{('A'.ord + lon_index).chr}#{('A'.ord + lat_index).chr}"

      lon -= lon_index * 20.0 # 20 degrees lon per grid
      lat -= lat_index * 10.0 # 10 degrees lat per grid

      # Map from 0 to 9
      lon_index = (lon / 2.0).to_i
      lat_index = lat.to_i

      grid += "#{lon_index}#{lat_index}"

      # Do the long grid if desired
      if length == 6
        lon -= lon_index * 2.0 # Now 2 degrees lon per grid remaining
        lat -= lat_index       # Now 1 degree lon per grid remaining

        # Map from 0 to 23 (a to x)
        lon_index = (lon / (2.0 / 24.0)).to_i
        lat_index = (lat / (1.0 / 24.0)).to_i

        # Convert to characters
        grid += "#{('a'.ord + lon_index).chr}#{('a'.ord + lat_index).chr}"
      end

      grid
    end

    def self.decode(grid)
      grid = grid.to_s
      validate_grid!(grid)

      lon = -180
      lat = -90
      
      ord0 = grid[0].upcase.ord - 'A'.ord
      ord1 = grid[1].upcase.ord - 'A'.ord
      ord2 = grid[2].to_i
      ord3 = grid[3].to_i
      
      lon += (360.0 / 18.0) * ord0 + (360.0 / 18.0 / 10.0) * ord2
      lat += (180.0 / 18.0) * ord1 + (180.0 / 18.0 / 10.0) * ord3
      
      if grid.length == 4
        lon += (360.0 / 18.0 / 10.0 / 2.0)
        lat += (180.0 / 18.0 / 10.0 / 2.0)
      else
        ord4 = grid[4].downcase.ord - 'a'.ord
        ord5 = grid[5].downcase.ord - 'a'.ord
        
        lon += (360.0 / 18.0 / 10.0 / 24.0) * (ord4 + 0.5)
        lat += (180.0 / 18.0 / 10.0 / 24.0) * (ord5 + 0.5)
      end
      
      return [lat, lon]
    end

    def self.is_grid?(str)
      str = str.to_s

      if str.length == 4
        return str.match(/[A-R]{2}[0-9]{2}/i)
      elsif str.length == 6
        return str.match(/[A-R]{2}[0-9]{2}[A-X]{2}/i)
      end

      false
    end

private

    def self.validate_coord!(coord)
      if coord[0] == nil || coord[0] < -90 || coord[0] > 90
        raise ArgumentError, 'Latitude must be between -90 and 90 degrees'
      end

      if coord[1] == nil || coord[1] < -180 || coord[1] > 180
        raise ArgumentError, 'Longitude must be between -180 and 180 degrees'
      end
    end

    def self.validate_grid!(grid)
      if !is_grid?(grid)
        raise ArgumentError, "Invalid grid: '#{grid}'"
      end
    end

    def self.validate_grid_length!(length)
      if length != 4 && length != 6
        raise ArgumentError, 'Grid length must be 4 or 6'
      end
    end
  end
end
