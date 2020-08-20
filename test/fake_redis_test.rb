require "test_helper"

class TinyFakeRedisTest < Minitest::Test
  def redis
    @redis ||= TinyFakeRedis.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::TinyFakeRedis::VERSION
  end

  def test_it_holds_data_in_a_hash
    assert_equal({}, redis.data)
  end

  def test_incr
    assert_nil redis.get("incr_test")
    assert_equal 1, redis.incr("incr_test")
    assert_equal 1, redis.get("incr_test")
    assert_equal 2, redis.incr("incr_test")
    assert_equal 2, redis.get("incr_test")
    redis.set("incr_test", 1000)
    assert_equal 1001, redis.incr("incr_test")
  end

  def test_decr
    assert_nil redis.get("decr_test")
    assert_equal(-1, redis.decr("decr_test"))
    assert_equal(-1, redis.get("decr_test"))
    assert_equal(-2, redis.decr("decr_test"))
    assert_equal(-2, redis.get("decr_test"))
    redis.set("decr_test", 1000)
    assert_equal 999, redis.decr("decr_test")
  end

  def test_set
    assert_nil redis.get("set_test")
    redis.set("set_test", "asdf")
    assert_equal "asdf", redis.get("set_test")
  end

  def test_get
    assert_nil redis.get("get_test")
    redis.set("get_test", {"asdf" => "asdf"})
    assert_equal({"asdf" => "asdf"}, redis.get("get_test"))
    test_modified = redis.get("get_test")
    assert_equal test_modified, redis.get("get_test")
    test_modified["new_key"] = "asdf"
    refute_equal test_modified, redis.get("get_test")
    assert_equal({"asdf" => "asdf", "new_key" => "asdf"}, test_modified)
    assert_equal({"asdf" => "asdf"}, redis.get("get_test"))
  end

  def test_lpush
    assert_nil redis.get("lpush_test")
    assert_equal 1, redis.lpush("lpush_test", "asdf")
    assert_equal 2, redis.lpush("lpush_test", "fdsa")
    assert_equal %w[ fdsa asdf ], redis.get("lpush_test")
  end

  def test_lrem
    assert_nil redis.get("lrem_test")

    set_values = lambda do
      5.times do
        redis.lpush("lrem_test", "a")
        redis.lpush("lrem_test", "b")
      end
    end

    set_values.call

    assert_equal 5, redis.lrem("lrem_test", 0, "a")
    assert_equal %w[ b b b b b ], redis.get("lrem_test")
    assert_equal 5, redis.lrem("lrem_test", 0, "b")
    assert_equal [], redis.get("lrem_test")

    set_values.call

    assert_equal 2, redis.lrem("lrem_test", 2, "a")
    assert_equal %w[ b b b a b a b a ], redis.get("lrem_test")
    assert_equal 2, redis.lrem("lrem_test", -2, "a")
    assert_equal %w[ b b b a b b ], redis.get("lrem_test")
    assert_equal 5, redis.lrem("lrem_test", 6, "b")
    assert_equal %w[ a ], redis.get("lrem_test")
    assert_equal 1, redis.lrem("lrem_test", -6, "a")
    assert_equal [], redis.get("lrem_test")
  end

  def test_lrange
    assert_nil redis.get("lrange_test")

    5.times do
      redis.lpush("lrange_test", "a")
      redis.lpush("lrange_test", "b")
    end

    assert_equal %w[ b a b a b a b a b a ], redis.lrange("lrange_test", 0)
    assert_equal %w[ b a b a ], redis.lrange("lrange_test", 0, 3)
    assert_equal %w[ a b a b a b a b a ], redis.lrange("lrange_test", 1)
    assert_equal %w[ a b a b a b a ], redis.lrange("lrange_test", 1, -3)
  end

  def test_rpush
    assert_nil redis.get("rpush_test")
    assert_equal 1, redis.rpush("rpush_test", "asdf")
    assert_equal 2, redis.rpush("rpush_test", "fdsa")
    assert_equal %w[ asdf fdsa ], redis.get("rpush_test")
  end

  def test_rpushx
    assert_nil redis.get("rpushx_test")
    assert_equal 0, redis.rpushx("rpushx_test", "asdf")
    assert_nil redis.get("rpushx_test")
    redis.set("rpushx_test", [])
    assert_equal 1, redis.rpushx("rpushx_test", "asdf")
    assert_equal 2, redis.rpushx("rpushx_test", "fdsa")
    assert_equal %w[ asdf fdsa ], redis.get("rpushx_test")
  end

  def test_rpop
    assert_nil redis.get("rpop_test")
    redis.set("rpop_test", %w[ a b c d e f ])

    while redis.get("rpop_test").size > 0
      assert_equal redis.get("rpop_test").last, redis.rpop("rpop_test")
    end
  end

  def test_rpoplpush
    assert_nil redis.get("rpoplpush_test")
    assert_nil redis.get("rpoplpush_test_2")
    redis.set("rpoplpush_test", %w[ a b c d e f ])

    while redis.get("rpoplpush_test").size > 0
      last_val = redis.get("rpoplpush_test").last
      assert_equal last_val, redis.rpoplpush("rpoplpush_test", "rpoplpush_test_2")
      assert_equal last_val, redis.get("rpoplpush_test_2").first
      refute_equal last_val, redis.get("rpoplpush_test").last
    end
    assert_equal %w[ a b c d e f ], redis.get("rpoplpush_test_2")
  end

  def test_keys
    holder = TinyFakeRedis.new
    assert_equal [], holder.keys
    holder.set("a", 1)
    assert_equal %w[ a ], holder.keys
    holder.set("b", 1)
    holder.set("ab", 1)
    assert_equal %w[ b ], holder.keys("[b-z]+")
    assert_equal %w[ a ab b ], holder.keys.sort
    assert_equal %w[ a ], holder.keys("[^b]+")
  end

  def test_del
    holder = TinyFakeRedis.new
    holder.set("a", 1)
    holder.set("b", 1)
    holder.set("c", 1)
    holder.set("d", 1)
    assert_equal 3, holder.del("b", "c", "d", "e", "f")
    assert_equal %w[ a ], holder.keys
  end

  def test_unbuilt_method
    assert_nil redis.asdf
    assert_nil redis.fdsa
    assert_nil redis.__send__ "#{rand}a"
  end
end
