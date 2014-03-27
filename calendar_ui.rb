require 'active_record'
require './lib/event'
require './lib/calendar_date'
require './lib/maigen'
require 'pry'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def start_menu
  system "clear"
  puts "\tInitializing Calendar...\n\n\n", "\t\t*   .   .   .   .   .\n\n", "\t\t.   *   .   .   .   .  \n\n", "\t\t.   .   *   .   .   .\n\n", "\t\t.   .   .   *   .   .\n\n", "\t\t.   .   .   .   *   .\n\n", "\t\t.   .   .   .   .   *\n\n", "\tCalendar Initialized.\n\n"

  puts "\tCalendar Bot 3000.", "\n\nTo create a new event, enter 'e'. To view the calendar, enter 'c'.", "To view events in chronological order, enter 'v'.", "To show events for a date or range of dates, enter 'd'.", "To exit, enter 'x'."
  input = gets.chomp
  case input
  when 'e'
    new_event
  when 'd'
    event_date
  when 'c'
    view_calendar
  when 'v'
    chrono_events
  when 'x'
    system "clear"
    puts "\n\n\n\nGoodbye.\n\n\n\n\n"
  else
    puts "That is not a valid choice. Press enter to choose again.\n\n\n"
    gets.chomp
    start_menu
  end
end
 ################################ CALENDAR METHODS ##########################

def view_calendar

end

################################ EVENT METHODS ##############################
def new_event
  system "clear"
  puts "What is the description of this event?\n\n"
  event_desc = gets.chomp
  puts "\n\nWhere is the location of this event?\n\n"
  locale = gets.chomp
  puts "\n\nWhen does this event begin? Enter in format YYYY-MM-DD HH:MM:SS\n\n"
  time_start = gets.chomp
  puts "\n\nWhen does this event end? Enter in format YYYY-MM-DD HH:MM:SS\n\n"
  time_end = gets.chomp
  new_event = Event.create(:description => event_desc, :location => locale, :start => time_start, :end => time_end)
  puts "#{new_event.description} has been added to the Calendar.\n\n", "\n\nWould you like to create a new event? (y/n)\n\n"
  input = nil
  until input == 'n'
    input = gets.chomp
    case input
    when 'y'
      new_event
    when 'n'
      start_menu
    else
      puts "That is not a valid choice. Press enter to choose again.\n\n\n"
      new_event
    end
  end
  new_event
end

def chrono_events
  system "clear"
  puts "\nHere is a list of all events in chronological order.\n\n"
  chrono = Event.all.order(:start)
  list = chrono.each { |event| puts "#{event.description} - #{event.start.strftime('%b %-d, %Y %l:%M%P')}" if ((event.start.to_s > Time.now.to_s) == true) }
  puts "\n\n\nTo edit an event, enter 'e', to delete an event, enter 'd'. To return to the main menu, enter 'm'.\n\n"
  input = gets.chomp
  case input
  when 'e'
    edit_menu
  when 'd'
    delete_menu
  when 'm'
    start_menu
  else
    puts "That is not a valid choice. Press enter to choose again.\n\n\n"
    chrono_events
  end
end

def event_date
  system "clear"
  puts "For events on a specific day, enter 'd'.", "To view events on a range of days, enter 'r'.", "To return to the main menu, enter 'm'."
  input = gets.chomp
  case input
  when 'd'
    date_search
  when 'r'
    range_search
  when 'm'
    start_menu
  else
    puts "That is not a valid choice. Press enter to choose again.\n\n\n"
    gets.chomp
    event_date
  end
end

def date_search
  system "clear"
  puts "\n\nWhat day would you like to view the events for? YYYY-MM-DD\n\n"
  input = gets.chomp.to_date
  binding.pry
  search_dates = Event.where({start: input})
  search_dates.each do |event|
    puts "\tEvents on :\n\n", "\tDescription: #{event.description}", "\tLocation: #{event.location}", "\tStart Date and Time: #{event.start.strftime('%b %-d, %Y %l:%M%P')}", "\tEnd Date and Time: #{event.end.strftime('%b %-d, %Y %l:%M%P')}\n\n\n"
  end
  gets.chomp
  event_date
end

def range_search
  system "clear"
  puts "\n\nSearching for calendar events for a range of dates.", "Enter the starting date. YYYY-MM-DD\n\n"
  start_search = gets.chomp
  puts "\n\nEnter the ending date. YYYY-MM-DD\n\n"
  end_search = gets.chomp
  Event.where({start: start_search})

end

def edit_menu
  puts "\n\nEnter the name of the event you would like to edit."
  input = gets.chomp
  edit_event = Event.where({description: input}).first
  puts "\tEvent to Edit:\n\n", "\tDescription: #{edit_event.description}", "\tLocation: #{edit_event.location}", "\tStart Date and Time: #{edit_event.start.strftime('%b %-d, %Y %l:%M%P')}", "\tEnd Date and Time: #{edit_event.end.strftime('%b %-d, %Y %l:%M%P')}\n\n\n"
  puts "What would you like to edit?\n\n", "Description, enter 'd',", "Location, enter 'l',", "Start, enter 's',", "End, enter 'e'.", "To go back to the main menu, enter 'm'.\n\n"
  user_choice = gets.chomp
  case user_choice
  when 'd'
    puts "\n\nWhat is the new description?\n\n"
    new_desc = gets.chomp
    edit_event.update(:description => new_desc)
    puts "\n\nEvent Updated!\n\n"
    chrono_events
  when 'l'
    puts "\n\nWhat is the new location?\n\n"
    new_loc = gets.chomp
    edit_event.update(:location => new_loc)
    puts "\n\nEvent Updated!\n\n"
    chrono_events
  when 's'
    puts "\n\nWhat is the new start date?\n\n"
    new_start = gets.chomp
    edit_event.update(:start => new_start)
    puts "\n\nEvent Updated!\n\n"
    chrono_events
  when 'e'
    puts "\n\nWhat is the new end date?\n\n"
    new_end = gets.chomp
    edit_event.update(:end => new_end)
    puts "\n\nEvent Updated!\n\n"
    chrono_events
  when 'm'
    system "clear"
    start_menu
  else
    puts "\n\nThat is not a valid choice. Press enter to choose again.\n\n\n"
    edit_menu
  end
end

def delete_menu
  puts "\nWhich event would you like to delete?\n\n"
  user_delete = gets.chomp
  event_delete = Event.where(:description => user_delete).destroy_all
  puts "\n\nThat event has been deleted!\n\n"
  puts "Would you like to delete another event? (y/n)"
  user_choice = gets.chomp
  case user_choice
  when 'y'
    chrono = Event.all.order(:start)
    list = chrono.each { |event| puts "#{event.description} - #{event.start.strftime('%b %-d, %Y %l:%M%P')}" if ((event.start.to_s > Time.now.to_s) == true) }
    delete_menu
  when 'n'
    start_menu
  else
    puts "\n\nThat is not a valid choice. Press enter to choose again.\n\n\n"
    end
end

start_menu
