require "simpletable/version"

DEFAULT_DIVIDER = "="
DEFAULT_PADDING = 2

module SimpleTable
  def create( objects, titles, methods, options = {} )
    raise "Mismatched number of methods and column titles" if titles.length != methods.length

    divider = options[:divider] || DEFAULT_DIVIDER
    padding = options[:padding] || DEFAULT_PADDING

    widths = []
    # calculate column widths
    titles.zip(methods).each do |title,method|
      widths << objects.collect { |o| o.send(method).to_s }.push(title).group_by(&:size).max.first + padding
    end

    # print table header
    print_row(titles,widths)
    puts divider * (widths.inject(:+) - padding)  # sum of column widths - padding

    # print table body
    objects.each do |o|
      data = methods.collect{ |m| o.send(m) } # collect row data
      print_row(data,widths)
    end
  end

private
  def print_row(data,widths)
    data.zip(widths).each { |d,w| print d.to_s.ljust(w) }
    print "\n"
  end
end
