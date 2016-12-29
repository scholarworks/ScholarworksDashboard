class StatsDashboard::ReportsController < ApplicationController

  def index
    # @total_visits_month ||= Event.where('event_date >= ?', Time.new.beginning_of_month).group('isbot').count
    @top_10_non_crawlers = EventsPresenters::HostReportPresenter.new
  end

end
