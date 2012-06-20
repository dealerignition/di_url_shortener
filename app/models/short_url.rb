class ShortUrl < ActiveRecord::Base
  validates_presence_of :url
  
  has_many :clicks
  
  before_save :set_shortened_url
  
  def key(id)
    Base58.encode(id)
  end
  
  def self.find_by_key(key)
    begin
      find(:first, :conditions => ['id = ?', Base58.decode(key.to_s)])
    rescue
      nil
    end
  end
  
  def click(referrer, ip_address)
    self.clicks.create(:referrer => referrer, :ip_address => ip_address)
  end
  
  def stats
    { :click_count => self.clicks.count }
  end
  
  private
  
  def set_shortened_url
    self.id = ShortUrl.all.length + 1
    self.shortened_url = "#{Rails.configuration.domain}/#{key(self.id)}"
  end
end
