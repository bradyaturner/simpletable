require "simpletable/version"

DEFAULT_DIVIDER = "="
DEFAULT_PADDING = 2
DEFAULT_PLACEHOLDER = "-"

class SimpleTable
  def from_objects( objects, titles, methods, options = {} )
    raise "Mismatched number of methods and column titles" if titles.length != methods.length
    @objects = objects
    @titles = titles
    @methods = methods
    @divider = options[:divider] || DEFAULT_DIVIDER
    @padding = options[:padding] || DEFAULT_PADDING
    self
  end

  def text
    widths = []
    # calculate column widths
    @titles.zip(@methods).each do |title,method|
      widths << @objects.collect { |o| call_method(o,method) }.push(title).group_by(&:size).max.first + @padding
    end

    # print table header
    text = row(@titles,widths)
    text << (@divider * (widths.inject(:+) - @padding)) << "\n"  # sum of column widths - padding

    # print table body
    @objects.each do |o|
      data = @methods.collect{ |m| call_method(o,m) } # collect row data
      text << row(data,widths)
    end
    text
  end

  def csv(separator=",")
    # quote strings w/ embedded separator characters
    titles = []
    @titles.each {|t| titles << (t.include?(separator) ? t.gsub(t,"\"#{t}\"") : t)}

    # print table header
    text = titles.join(separator) << "\n"

    # print table body
    @objects.each do |o|
      data = @methods.collect{ |m| call_method(o,m) } # collect row data
      text << data.join(separator) << "\n"
    end
    text
  end

private
  def row(data,widths)
    row = ""
    data.zip(widths).each { |d,w| row << d.to_s.ljust(w) }
    row << "\n"
  end

  def call_method(obj,method)
    begin
      obj.send(method).to_s
    rescue NoMethodError
      DEFAULT_PLACEHOLDER
    end
  end
end
