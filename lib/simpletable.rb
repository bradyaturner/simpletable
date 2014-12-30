require "simpletable/version"

DEFAULT_DIVIDER = "="
DEFAULT_PADDING = 2

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

  def print_text
    widths = []
    # calculate column widths
    @titles.zip(@methods).each do |title,method|
      widths << @objects.collect { |o| o.send(method).to_s }.push(title).group_by(&:size).max.first + @padding
    end

    # print table header
    print_row(@titles,widths)
    puts @divider * (widths.inject(:+) - @padding)  # sum of column widths - padding

    # print table body
    @objects.each do |o|
      data = @methods.collect{ |m| o.send(m) } # collect row data
      print_row(data,widths)
    end
  end

  def print_csv(separator=",")
    # quote strings w/ embedded separator characters
    titles = []
    @titles.each {|t| titles << (t.include?(separator) ? t.gsub(t,"\"#{t}\"") : t)}

    # print table header
    puts titles.join separator

    # print table body
    @objects.each do |o|
      data = @methods.collect{ |m| o.send(m) } # collect row data
      puts data.join separator
    end
  end

private
  def print_row(data,widths)
    data.zip(widths).each { |d,w| print d.to_s.ljust(w) }
    print "\n"
  end
end
