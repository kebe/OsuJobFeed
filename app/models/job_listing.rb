class JobListing < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true
  validates :department, presence: true
  
  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
  end
  
  #if this application were to go live we could use a cron job to run this method as a task periodicaly 
  #to update the feed with new entries
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end
  
  private
  
  def self.add_entries(entries)
    entries.each do |entry|
      unless exists? :entry_id => entry.id
        create!(
          :entry_id => entry.id,
          :published  => entry.published,
          :updated  => entry.updated,
          :link => entry.url,
          :title  => entry.title,
	        :content  => entry.content,
	        :department  => entry.author
        )
      end
    end
  end
  
  def self.search(search= nil)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def self.filter(departments)
    if departments.nil? # user did not filter department
      scoped
    else
      departments.reject!(&:blank?)   
      if !departments.empty?
        where(department: departments)
      else
        scoped
      end   
    end
  end

end
