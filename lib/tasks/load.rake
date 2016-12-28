require 'csv'

def log_type(line)
  line[24,5].strip unless line.length < 30
end

def log_date(line)
  line[0,10]
end

def log_time(line)
  DateTime.parse(line[0,19]) # .to_time.to_i unless line.length < 30
end

def log_event(line)
  line[30..-1].partition(" ").first unless line[30,3] != 'org' # line.index('@')].strip!
end

def log_ip(line)
end

def log_content(line)
  line.partition(" @ ").last.split(":")
end

def index_chunk(chunk)
  logged_param = chunk.split("=")
  case logged_param.first
  when "ip_addr"
    @ip_addr_hash[logged_param.last] += 1
    # puts Resolv.getname logged_param.last
  when "handle"
    @item_viewed[logged_param.last.strip] += 1
  when "collection_id"
    @coll_viewed[logged_param.last.strip] += 1
  when "community_id"
    @comm_viewed[logged_param.last.strip] += 1
  end
end

def usage_event(event_array)
  # binding.pry if event_array[4].nil?
  if event_array[2] != 'workflow_item'
    { :user => event_array[0],
      event_array[1].split("=").first.to_sym => event_array[1].split("=").last,
      event_array[2].split("=").first.to_sym => event_array[2].split("=").last, # :ip_addr => event_array[2],
      :event => event_array[3],
      event_array[4].split("=").first.to_sym => event_array[4].split("=").last } # :id => event_array[4] }
  else
    { :user => event_array[0],
      event_array[1].split("=").first.to_sym => event_array[1].split("=").last,
      :event => event_array[2], # .split("=").first.to_sym => event_array[2].split("=").last, # :ip_addr => event_array[2],
      event_array[3].split("=").first.to_sym => event_array[3].split("=").last } # :id => event_array[4] }
  end
end

namespace :load do

  task :communities, [:file] =>  [:environment] do |t, args|
    puts "Loading Communities"

    @source_file = args[:file] or raise "No source input file provided."

    File.open(@source_file).each do |lines|
      puts lines[0..13].to_i.to_s + " ==> " + lines[16..-1].strip
      c = Community.new(id: lines[0..13].to_i,
                        name: lines[16..-1].strip)
      c.save
    end
  end

  task :collections, [:file] => [:environment] do |t, args|
    puts "Loading Collection"

    @source_file = args[:file] or raise "No source input file provided."

    File.open(@source_file).each do |lines|
      comm = Community.find(lines[0..13].to_i)
      # comm.collections.create(id: lines[16..29].to_i,
      #                      name: lines[31..-1].strip)
      # comm.save
      c = Collection.new(id: lines[16..29].to_i,
                        name: lines[31..-1].strip)
      c.save
      comm.collections << c
      c.save
    end

  end

  task :events, [:file] => [:environment] do |t, args|
    puts "Loading Events"

    @source_file = args[:file] or raise "No source input file provided."

    File.open(@source_file).each do |line|
      line = line.strip
      # event_class = line[24,5].strip unless line.length < 30
      # event_source = line[30..-1].partition(" ").first unless line[30,3] != 'org' # line.index('@')].strip!
      case log_type(line)
      when "INFO"
        if log_event(line) == 'org.dspace.usage.LoggerUsageEventListener'
          @events_array = usage_event(log_content(line))
          user = User.find_or_create_by(username: @events_array[:user])
          # user.save
          # puts @events_array[:user]
          # puts @events_array[:ip_addr]
          # puts @events_array[:event]
          bot = Bot.find_by(ip_addr: @events_array[:ip_addr])
          isbot = bot.nil? ? FALSE : TRUE
          params = {ip_addr: @events_array[:ip_addr],
                    isbot: isbot,
                    event_type: @events_array[:event],
                    event_class: "INFO",
                    source: "org.dspace.usage.LoggerUsageEventListener",
                    event_date: log_time(line)}
          event = Event.new(params)
          event.save
          user.events << event
          case @events_array[:event]
          when "view_comunity"
            community = Community.find_by_id(@events_array[:community_id])
            unless community.nil?
              community.events << event
              community.save
            end
          when "view_collection"
            collection = Collection.find_by_id(@events_array[:collection_id])
            unless collection.nil?
              collection.events << event
              collection.save
            end
          when "view_item"
            item = Item.find_by(handle: @events_array[:handle])
            unless item.nil?
              item.events << event
              item.save
            end
          when "view_bitstream"
            bitstream = Bitstream.find_by_id(@events_array[:bitstream_id])
            unless bitstream.nil?
              bitstream.events << event
              bitstream.save
            end
          end
        end
      end
    end
  end

  task :subcommunities, [:file] => [:environment] do |t, args|
    puts "Loading SubCommunities..."
    @source_file = args[:file] or raise "No source input file provided."

    File.open(@source_file).each do |line|
      line = line.strip
      comm = line[7..21].to_i
      sub_comm = line[24..-1].to_i
      puts comm.to_s + " ==> " + sub_comm.to_s
      child_comm = Community.find_by_id(sub_comm)
      parent_comm = Community.find_by_id(comm)
      unless child_comm.nil?
        parent_comm.subcommunities << child_comm
        parent_comm.save
      end
    end
  end

  task :items, [:file] => [:environment] do |t, args|
    puts "Loading Items..."
    @source_file = args[:file] or raise "No source input file provided."
    File.open(@source_file).each do |line|
      line = line.strip
      handle = line[0..14].strip
      collid = line[16..-1].to_i
      coll = Collection.find_by_id(collid)
      unless coll.nil?
        item = Item.new(handle: handle)
        item.save
        coll.items << item
      end
    end
  end

  task :bitstreams, [:file] => [:environment] do |t, args|
    puts "Loading Bitstreams..."
    @source_file = args[:file] or raise "No source input file provided."
    File.open(@source_file).each do |line|
      line = line.strip
      fields = line.split('|')
      # puts fields[0].strip + " => " + fields[1].strip + " => " + fields[2].strip + " => " + fields[3].strip + " => " + fields[4].strip
      bitstream = Bitstream.find_by_id(fields[0].strip.to_i)
      if bitstream.nil?
        item = Item.find_by(handle: fields[1].strip)
        unless item.nil?
          bitstream = Bitstream.new(id: fields[0].strip.to_i,
                                    name: fields[2].strip,
                                    size_bytes: fields[3].strip.to_i)
          bitstream.save
          item.bitstreams << bitstream
        end
      end
    end
  end

  task :bots, [:file] => [:environment] do |t, args|
    puts "Loading Bots..."
    @source_file = args[:file] or raise "No source input file provided."
    File.open(@source_file).each do |line|
      line = line.strip
      fields = line.split('.')
      if fields[2].nil?
        puts "Class b"
      end
      if fields[3].nil?
        for i in 0..255
          # puts "Class C: " + line + "." + i.to_s
          ip_addr = line + "." + i.to_s
          bot = Bot.new(ip_addr: ip_addr)
          bot.save
        end
      else
        bot = Bot.new(ip_addr: line)
        bot.save
      end
    end
  end

end
