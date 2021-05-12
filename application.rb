class Time
  attr_accessor :hour, :minute

  class << self
    def convert_string_to_time string
      check_input_valid! string

      time = self.new
      split_data = string.split ":"
      time.hour = split_data.first.to_i
      time.minute = split_data.last.to_i

      check_time_valid! time
      time
    end

    #time_1 > time_2 return 1
    #time_1 = time_2 return 0
    #time_1 < time_2 return -1
    def compare time_1, time_2
      return 1 if time_1.hour > time_2.hour
      return -1 if time_1.hour < time_2.hour
      return 1 if time_1.minute > time_2.minute
      return -1 if time_1.minute < time_2.minute

      0
    end

    private

    def check_input_valid! data
      raise Exception unless data.strip.match(/\d{1,2}:\d{1,2}/)
    end

    def check_time_valid! time
      hour = time.hour
      minute = time.minute
      raise Exception if hour < 0 || hour > 23 || minute < 0 || minute > 59
    end
  end
end

class Application
  @@lunch = "N"
  @@dinner = "N"
  @@ot_time
  @@check_out_time
  @@check_in_time
  LUNCH_START_TIME_STR = "12:00"
  LUNCH_END_TIME_STR = "13:00"
  DINNER_TIME_STR = "21:00"

  class << self
    def run
      print "Enter check-in time: "
      @@check_in_time = Time.convert_string_to_time gets.chomp
      print "Enter check-out time: "
      @@check_out_time = Time.convert_string_to_time gets.chomp

      raise Exception if Time.compare(@@check_out_time, @@check_in_time).negative?
      calculate_ot_time
      check_for_lunch
      check_for_dinner

      puts "OT: #{@@ot_time}, Lunch: #{@@lunch}, Dinner: #{@@dinner}"
    rescue Exception
      puts "Invalid data"
    end

    private

    def calculate_ot_time
      hour = 0
      minute = 0
      if @@check_out_time.minute >= @@check_in_time.minute
        minute = @@check_out_time.minute - @@check_in_time.minute
        hour = @@check_out_time.hour - @@check_in_time.hour
      else
        minute =  60 + @@check_out_time.minute - @@check_in_time.minute
        hour = @@check_out_time.hour - @@check_in_time.hour - 1
      end
      @@ot_time = hour + (minute / 60.0).round(2)
    end

    def check_for_lunch
      lunch_start_time = Time.convert_string_to_time LUNCH_START_TIME_STR
      lunch_end_time = Time.convert_string_to_time LUNCH_END_TIME_STR
      if @@ot_time > 4 &&
         Time.compare(@@check_in_time, lunch_start_time) < 1 &&
         Time.compare(lunch_end_time, @@check_out_time) < 1
        @@ot_time -= 1
        @@lunch = "Y"
      end
    end

    def check_for_dinner
      dinner_time = Time.convert_string_to_time DINNER_TIME_STR
      if @@ot_time > 3 &&
         Time.compare(@@check_in_time, dinner_time) < 1 &&
         Time.compare(dinner_time, @@check_out_time) < 1
        @@dinner = "Y"
      end
    end
  end
end

Application.run
