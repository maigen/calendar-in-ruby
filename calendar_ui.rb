require 'active_record'
require './lib/event'
require './lib/calendar_date'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def start_menu
  system "clear"
  puts "\tInitializing Calendar...\n\n\n", "\t\t* . . . . .\n\n", "\t\t. * . . . .\n\n", "\t\t. . * . . .\n\n", "\t\t. . . * . .\n\n", "\t\t. . . . * .\n\n", "\t\t. . . . . *\n\n", "\tCalendar Initialized.\n\n"
  puts "To create a new event, enter 'e'. To view a list of events, enter 'l'.", "To exit, enter 'x'."
  input = gets.chomp
  case input
  when 'e'
    system "clear"
    new_event
  when 'l'
    system "clear"
    list_events
  when 'x'
    system "clear"
    puts "\n\n\n\nGoodbye.\n\n\n\n\n"
  else
    puts "That is not a valid choice. Press enter to choose again.\n\n\n"
    gets.chomp
    start_menu
  end
end



start_menu
