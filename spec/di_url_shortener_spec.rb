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
        post '/', {:url => 'http://example.com/'}, {'HTTP_AUTHORIZATION' => valid_credentials}
        ShortUrl.count.should == count + 1
      end
    end
    
    context "creating valid urls" do
      before(:each) do
        url = 'http://example.com/'
        post '/', {:url => 'http://example.com/'}, {'HTTP_AUTHORIZATION' => valid_credentials}
        
        @short_url = ShortUrl.first
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
        url = 'http://example.com/'
        post '/', {:url => 'http://example.com/'}, {'HTTP_AUTHORIZATION' => valid_credentials}
        
        @short_url = ShortUrl.first
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
  end
end