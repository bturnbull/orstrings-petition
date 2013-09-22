require 'spec_helper'

describe ApplicationHelper do

  describe 'friendly_time' do

    it 'should return "just now" for near past times' do
      friendly_time(60.seconds.ago).should eq('just now')
    end

    it 'should return time_ago_in_words for not as near past times' do
      friendly_time(10.minutes.ago).should eq('about ' + time_ago_in_words(10.minutes.ago) + ' ago')
    end

    it 'should return day of week and time for couple days past times' do
      friendly_time(2.days.ago).should eq(2.days.ago.strftime('on %A around %l %p'))
    end

    it 'should return day of week, date, and time for older past times' do
      friendly_time(7.days.ago).should eq(7.days.ago.strftime('on %A, %B %-d around %l %p'))
    end
  end

  describe 'friendly_date' do

    it 'should return the date in friendly format' do
      friendly_date(1.day.ago).should eq(1.day.ago.strftime("%A, %B %-d %Y"))
    end
  end
end
