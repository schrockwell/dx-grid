require 'test_helper'

class DX::GridTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DX::Grid::VERSION
  end

  def test_encode
    assert_equal 'JJ00', DX::Grid.encode([0, 0], :length => 4)
    assert_equal 'JJ00', DX::Grid.encode([0, 0])
    assert_equal 'JJ00aa', DX::Grid.encode([0, 0], :length => 6)
    assert_equal 'FN22', DX::Grid.encode([42.481076, -75.037847])
    assert_equal 'FN22cd', DX::Grid.encode([42.147743, -75.787847], :length => 6)
  end

  def test_encode_arguments
    assert_raises ArgumentError do
      DX::Grid.encode([0, 0], :length => 5)
    end

    [[-91, 0], [0, -181], [91, 0], [0, 181]].each do |coord|
      assert_raises ArgumentError do
        DX::Grid.encode(coord)
      end
    end
  end

  def test_decode
    assert_equal [0.5, 1.0], DX::Grid.decode('JJ00')
    assert_equal [42.5, -75.0], DX::Grid.decode('FN22')
    puts DX::Grid.decode('FN22ab')


    assert_in_delta -77.854, DX::Grid.decode('AB12cd')[0], 0.001
    assert_in_delta -177.791, DX::Grid.decode('AB12cd')[1], 0.001

    assert_equal [-89.5, -179], DX::Grid.decode('AA00')
    assert_equal [89.5, 179], DX::Grid.decode('RR99')
  end

  def test_decode_arguments
    %w{abcdef st12aa st12 fn22yz test}.each do |grid|
      assert_raises ArgumentError do
        DX::Grid.decode(grid)
      end
    end
  end

  def test_is_grid
    assert DX::Grid.is_grid?('FN22')
    assert DX::Grid.is_grid?('fn22')
    assert DX::Grid.is_grid?('AA00aa')
    assert DX::Grid.is_grid?('ab12xx')
    assert DX::Grid.is_grid?('MO00OO')
    assert DX::Grid.is_grid?('lo00ol')

    assert !DX::Grid.is_grid?('FN')
    assert !DX::Grid.is_grid?('st12')
    assert !DX::Grid.is_grid?('fn22yz')
    assert !DX::Grid.is_grid?('hello world')
    assert !DX::Grid.is_grid?(nil)
    assert !DX::Grid.is_grid?('')
    assert !DX::Grid.is_grid?(5)
    assert !DX::Grid.is_grid?(Math::PI)
  end
end
