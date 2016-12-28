module EventsPresenters
  class CurrentMonthPresenter
    def total_visits_month
      @total_visits_month ||= Event.where('event_date >= ? AND isbot = ?', Time.new.beginning_of_month, false).count #.group('isbot')
      # put @total_visits_month
    end

    def total_item_views
      @total_item_views ||= Event.where('event_date >= ? AND event_type = "view_item" AND isbot = ?', Time.new.beginning_of_month, false).count #.group('isbot')
      # put @total_visits_month
    end

    def total_collection_views
      @total_collection_views ||= Event.where('event_date >= ? AND event_type = "view_collection" AND isbot = ?', Time.new.beginning_of_month, false).count #.group('isbot')
      # put @total_visits_month
    end

    def total_community_views
      @total_community_views ||= Event.where('event_date >= ? AND event_type = "view_community" AND isbot = ?', Time.new.beginning_of_month, false).count #.group('isbot')
      # put @total_visits_month
    end

    def total_bitstream_views
      @total_bitstream_views ||= Event.where('event_date >= ? AND event_type = "view_bitstream" AND isbot = ?', Time.new.beginning_of_month, false).count #.group('isbot')
      # put @total_visits_month
    end

    def total_views
      @total_views ||= Event.where('event_date >= ? AND isbot = ?', Time.new.beginning_of_month, false) #.group('isbot')
    end

    def total_by_date
      @total_by_date ||= total_views.group_by{|e| [e.event_date.to_date]}
    end
  end
end
