module ApplicationHelper

  def friendly_time(time)
    if time > 90.seconds.ago
      'just now'
    elsif time > 12.hours.ago
      'about ' + time_ago_in_words(time) + ' ago'
    elsif time > 3.days.ago
      time.in_time_zone(Rails.configuration.display_time_zone).strftime('on %A around %l %p')
    else
      time.in_time_zone(Rails.configuration.display_time_zone).strftime('on %A, %B %-d around %l %p')
    end
  end

  def friendly_date(date)
    date.in_time_zone(Rails.configuration.display_time_zone).strftime("%A, %B %-d %Y")
  end
end
