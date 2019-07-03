require_relative 'util.rb'
# require the voting systems
Dir.glob(__dir__ + '/systems/*.rb') {|f| require_relative f}