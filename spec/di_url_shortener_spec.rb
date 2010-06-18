require File.dirname(__FILE__) + '/spec_helper'

describe 'Url Shortener' do
  def app
    @app ||= Sinatra::Application
  end
  
  before(:each) do
    ShortUrl.destroy_all
  end
   
  context "creating short urls" do
    context "with invalid login" do
      it "should not allow url to be posted without authentication" do
        post '/', { :url => 'http://example.com' }
        last_response.status.should == 401
      end
      
      it "should not allow url to be posted with incorrect login" do
        post '/', {:url => 'http://example.com/'}, {'HTTP_AUTHORIZATION' => invalid_credentials}
        last_response.status.should == 401
      end
    end
    
    context "with valid login" do
      it "should allow url to be posted with correct authentication" do
        post '/', {:url => 'http://example.com/'}, {'HTTP_AUTHORIZATION' => valid_credentials}
        last_response.status.should == 200
      end
      
      it "should add the short url to the database" do
        count = ShortUrl.count
        create_a_url('http://example.com/')
        ShortUrl.count.should == count + 1
      end
    end
    
    context "creating valid urls" do
      before(:each) do
        create_a_url('http://example.com/')
      end
      
      it "should store the correct long url" do
        @short_url.url.should == 'http://example.com/'
      end
      
      it "should add the short url to the database" do
        @short_url.shortened_url.should_not == nil
      end
      
      it "should return a JSON representation of the created url" do
       last_response.content_type.should == 'application/json'
      end
    end
    
    context "redirecting urls" do
      before(:each) do
        create_a_url('http://example.com/')
      end
      
      it "should show a not found page (404) if the url cannot be found" do
        get '/bad_key'
        last_response.status.should == 404
      end
      
      it "should redirect to the correct url when hits a given short url" do
        get "/#{@short_url.key}"
        last_response.should be_redirect
        last_response["Location"].should == @short_url.url
      end
    end
    
    context "tracking clicks" do
      before(:each) do
        create_a_url('http://example.com/')
      end
      
      it "should start with 0 clicks" do
        @short_url.clicks.count.should == 0
      end
      
      it "should add a click entry" do
        click_count = @short_url.clicks.count
        get "/#{@short_url.key}"
        @short_url.clicks.count.should == click_count + 1
      end
      
      it "should record the request referrer" do
        get "/#{@short_url.key}"
        @short_url.clicks.first.referrer.should == "/"
      end
      
      it "should record the request ip address" do
        get "/#{@short_url.key}"
        @short_url.clicks.first.ip_address.should == "127.0.0.1"
      end
    end
    
    context "retrieving click statistics" do
      before(:each) do
        create_a_url('http://example.com/')
        10.times { get "/#{@short_url.key}" }
      end
      
      it "should return a hash with the # of clicks" do
        statistics = JSON.parse((get "/stats/#{@short_url.id}").body)
        statistics["click_count"].should == 10
      end
    end
  end
end