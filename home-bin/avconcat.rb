#!/usr/bin/env ruby

#
# Concatenates audio files together using avconv.
#
# Usage: avconcat -o <output> <inputs...>
#
# @see https://gist.githubusercontent.com/yjerem/11046717/raw/d88584af0119616f7ba45f686a1ea3b6eb422ed7/avconcat.rb

output = nil
output_arg = false
files = ARGV.map do |arg|
  if arg == "-o"
    if output_arg
      puts "Error: output file specified more than once!"
      exit
    else
      output_arg = true
      nil
    end
  elsif output_arg
    output = arg
    output_arg = false
    nil
  else
    arg
  end
end.compact

def usage
  puts "Usage: avconcat -o <output> <inputs...>"
end

if output.nil?
  puts "Error: no output specified."
  usage
  exit
elsif files.empty?
  puts "Error: no inputs specified."
  usage
  exit
else
  exec("avconv", "-i", "concat:" + files.join("|"), output)
end
