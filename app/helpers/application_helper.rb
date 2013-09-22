module ApplicationHelper

  def friendly_time(time)
    if time > 90.seconds.ago
      'just now'
    elsif time > 12.hours.ago
      'about ' + time_ago_in_words(time) + ' ago'
    elsif time > 3.days.ago
      time.strftime('on %A around %l %p')
    else
      time.strftime('on %A, %B %-d around %l %p')
    end
  end
end
