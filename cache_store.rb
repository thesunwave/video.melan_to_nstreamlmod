require 'moneta'

module CacheStore
  extend self

  def store
    @store ||= Moneta.new(:File, dir: 'moneta')
  end
end