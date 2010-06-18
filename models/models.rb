class ShortUrl < ActiveRecord::Base
  validates_presence_of :url
  
  has_many :clicks
  
  after_create :set_shortened_url
  
  def key
    Base58.encode(self.id)
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
  
  private
  
  def set_shortened_url
    self.shortened_url = "#{DOMAIN}/#{key}" if self.id
    self.save
  end
end

class Click < ActiveRecord::Base
  belongs_to :short_url
end