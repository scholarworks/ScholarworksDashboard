module EventsPresenters
  class HostReportPresenter
    def top_10_non_crawlers
      # @top_10_non_crawlers ||= Event.where('event_date >= ? AND isbot = ?', Time.new.beginning_of_month, false).group('ip_addr').order("count_ip_addr desc").count('ip_addr').first(10).map {|host| [host[0], (Resolv.getname(host[0]) rescue "no-host-name"), host[1]]}
      @top_10_non_crawlers ||= Event.where('isbot = ?', false).group('ip_addr').order("count_ip_addr desc").count('ip_addr').first(10).map {|host| [host[0], (Resolv.getname(host[0]) rescue "no-host-name"), host[1]]}
      # put @total_visits_month
    end


    def top_10_crawlers
      # @top_10_crawlers ||= Event.where('event_date >= ? AND isbot = ?', Time.new.beginning_of_month, true).group('ip_addr').order("count_ip_addr desc").count('ip_addr').first(10).map {|host| [host[0], (Resolv.getname(host[0]) rescue "no-host-name"), host[1]]}
      @top_10_crawlers ||= Event.where('isbot = ?', true).group('ip_addr').order("count_ip_addr desc").count('ip_addr').first(10).map {|host| [host[0], (Resolv.getname(host[0]) rescue "no-host-name"), host[1]]}
      # put @total_visits_month
    end
  end
end
