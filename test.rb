require 'minitest/autorun'
require './dependencies.rb'

class TestDep < Minitest::Test
  ALPHA = ('A'..'Z')

  def setup
    @dep = Dependencies.new
  end

  def test_basic
    @dep.add_direct('A', %w{ B C } )
    @dep.add_direct('B', %w{ C E } )
    @dep.add_direct('C', %w{ G } )
    @dep.add_direct('D', %w{ A F } )
    @dep.add_direct('E', %w{ F } )
    @dep.add_direct('F', %w{ H } )

    assert_equal( %w{ B C E F G H }, @dep.dependencies_for('A'))
    assert_equal( %w{ C E F G H }, @dep.dependencies_for('B'))
    assert_equal( %w{ G }, @dep.dependencies_for('C'))
    assert_equal( %w{ A B C E F G H }, @dep.dependencies_for('D'))
    assert_equal( %w{ F H }, @dep.dependencies_for('E'))
    assert_equal( %w{ H }, @dep.dependencies_for('F'))
  end

  def test_looping
    @dep.add_direct('A',['B'])
    @dep.add_direct('B',['C'])
    @dep.add_direct('C',['A'])

    assert_equal( %w{ B C }, @dep.dependencies_for('A'))
  end

  def test_scale
    test = {}
    ALPHA.each do |l|
      expected = ALPHA.to_a.shuffle[0,rand(6)]
      expected.delete(l)
      @dep.add_direct(l,expected)
      test[l] = expected
    end
    ALPHA.each do |l|
      result = @dep.dependencies_for(l)
      test[l].each do |letter|
        assert result.include?(letter), "Deps for #{l}  - #{result} didn't include #{letter}" 
      end
    end
  end 

end
