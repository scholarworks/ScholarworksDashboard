class StatsDashboard::HomepageController < ApplicationController

  def index
    # @total_visits_month ||= Event.where('event_date >= ?', Time.new.beginning_of_month).group('isbot').count
    @current_month_presenter = EventsPresenters::CurrentMonthPresenter.new
  end

end
