#!/usr/bin/env ruby

require './simpletable'

class TestObject
  attr_reader :p1, :p2, :p3
  def initialize(p1,p2,p3)
    @p1 = p1
    @p2 = p2
    @p3 = p3
  end
end

include SimpleTable

titles = [ "Title A", "Title B is very long, the longest", "Title C" ]
titles2 = [ "Title A", "Title B", "Title C is very long, the longest" ]
methods = [ :p1, :p2, :p3 ]

objs = []
objs << TestObject.new("thisisaword","anotherword","short")
objs << TestObject.new("also","kindof","longerword")
objs << TestObject.new("eleven","twelve","thirteen")
objs << TestObject.new("fourteen","fifteen","sixteen")
objs << TestObject.new("thisisthebiggestword","thisisthebiggestword","thisisthebiggestword")

SimpleTable.create(objs,titles,methods)
SimpleTable.create(objs,titles,methods,{:divider=>"*"})
SimpleTable.create(objs,titles,methods,{:divider=>"-",:padding=>5})
SimpleTable.create(objs,titles2,methods,{:divider=>"-",:padding=>5})
