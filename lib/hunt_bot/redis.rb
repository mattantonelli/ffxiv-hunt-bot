module HuntBot
  module Redis
    extend self

    REDIS = ::Redis::Namespace.new(:hunts)

    def get(key)
      REDIS.get(key)
    end

    def del(key)
      REDIS.del(key)
    end

    def hget(key, field)
      REDIS.hget(key, field)
    end

    def hgetall(key)
      REDIS.hgetall(key)
    end

    def keys
      REDIS.keys
    end

    def hkeys(key)
      REDIS.hkeys(key)
    end

    def hexists?(key, field)
      REDIS.hexists(key, field)
    end

    def get_json(key)
      get(key) || '{}'
    end

    def set(key, value)
      REDIS.set(key, value)
    end

    def hset(key, field, value)
      REDIS.hset(key, field, value)
    end

    def hdel(key, field)
      REDIS.hdel(key, field)
    end
  end
end
