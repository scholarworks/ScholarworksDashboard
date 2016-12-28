class EventsController < ApplicationController

  helper_method :total_visits_month

  def index
    @events = Event.all.group_by{|event| event.event_type}
    ip_addresses
    dates
  end

  def show
    # @events = Event.find(params[:id])
    @events = Event.where('event_date BETWEEN ? AND ?', DateTime.parse('2016-12-15').beginning_of_day, DateTime.parse('2016-12-15').end_of_day)
  end

  def ip_addresses
    @ip_addresses ||= Event.all.group('ip_addr').order('count_ip_addr desc').count('ip_addr')
  end

  def dates
    @dates ||= Event.pluck("distinct DATE(event_date)")
  end

  def day
    # Date Query for day
    @events = Event.where('event_date BETWEEN ? AND ?', DateTime.parse('2016-12-15').beginning_of_day, DateTime.parse('2016-12-15').end_of_day)
  end

  def total_visits_yesterday
    @total_visits_yesterday ||= Event.where('event_date >= ?', Time.new.yesterday.beginning_of_day).group('isbot').count
  end

  def total_visits_week
    @total_visits_week ||= Event.where('event_date >= ?', Time.new.beginning_of_week).group('isbot').count
  end

#  def total_visits_month
#    @total_visits_month ||= Event.where('event_date >= ?', Time.new.beginning_of_month).group('isbot').count
    # put @total_visits_month
#  end

end
