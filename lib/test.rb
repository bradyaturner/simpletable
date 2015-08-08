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

titles = [ "Title A", "Title B is very long, the longest", "Title C", "Title D" ]
titles2 = [ "Title A", "Title B", "Title C", "Title D is very long; the longest" ]
methods = [ :p1, :p2, :p4, [:p3,:length] ]

objs = []
objs << TestObject.new("thisisaword","anotherword","short")
objs << TestObject.new("also","kindof","longerword")
objs << TestObject.new("eleven","twelve","thirteen")
objs << TestObject.new("fourteen","fifteen","sixteen")
objs << TestObject.new("thisisthebiggestword","thisisthebiggestword","thisisthebiggestword")

t = SimpleTable.new

puts t.from_objects(objs,titles,methods).text << "\n"
t.placeholder = "+"
puts t.csv("+") << "\n"

puts t.from_objects(objs,titles,methods,{:divider=>"*",:placeholder=>"-"}).text << "\n"
puts t.csv(",") << "\n"

puts t.from_objects(objs,titles,methods,{:divider=>"-",:padding=>5}).text << "\n"
puts t.csv << "\n"

puts t.from_objects(objs,titles2,methods,{:divider=>"-",:padding=>5}).text << "\n"
puts t.csv(";") << "\n"
