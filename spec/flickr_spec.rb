require File.dirname(__FILE__) + "/spec_helper"
require "flickr"

describe "The Flickr API" do
  
  before do
    Array.class_eval { alias :pmap :map } # disable threaded map since specs behave weird with it
  end
  
  before do
    @api = Flickr.new("api_key", "user_id", "storage_dir")
  end

  def url_for(service, params={})
    request = { :api_key => "api_key", :user_id => "user_id", :method => service }.merge(params).to_query_string
    "http://api.flickr.com/services/rest/?#{request}"
  end
  
  def self.when_getting(method, options={})
    fixture = options[:return_fixture] ? File.read("#{File.dirname(__FILE__)}/fixtures/#{options[:return_fixture]}.xml") : ""
    before do
      @api.stub!(:open).with(/#{method}/).and_return(fixture)
    end
  end
  
  describe "getting a list of photosets" do
    
    when_getting "flickr.photosets.getList", :return_fixture => "photosets"
    when_getting "flickr.photos.getSizes", :return_fixture => nil

    it "should return a list of Photosets" do
      @api.photosets.each {|set| set.should be_a_kind_of(Flickr::Photoset) }
    end
    
    describe "and for the first set" do      
      before do
        @set = @api.photosets.first
      end

      it "should have the title of the newest set" do
        @set.title.should == "El Apartamento Nuevo"
      end

      it "should have the slug of the newest set" do
        @set.slug.should == "72157606641297899"
      end
      
      it "should have the description of the newest set" do
        @set.description.should == "Acá me voy a mudar a fines de agosto. Veamos como va progresando =)"
      end

      it "should have an object that responds to all photo messages" do
        @set.photo.slug.should == "2775977060"
      end
    end
    
  end
  
  describe "getting the photos in a photoset" do
    
    when_getting "flickr.photosets.getPhotos", :return_fixture => "photoset"
    when_getting "flickr.photos.getSizes", :return_fixture => "photo"
    
    before do
      @set = @api.photos_in_set("72157606796637486")
    end
    
    it "should return a list of Photos" do
      @set.each {|photo| photo.should be_a_kind_of(Flickr::Photo) }
    end
    
    describe "and for the first photo" do    
      before do
        @photo = @set.first
      end

      it "should have the slug of the first photo" do
        @photo.slug.should == "2773144845"
      end
      
      it "should have the photo url of the first photo" do
        @photo.url.should == "http://farm4.static.flickr.com/3108/2773144845_eebbc25276_o.jpg"
      end
      
      it "should have the thumbnail url of the first photo" do
        @photo.thumb.should == "http://farm4.static.flickr.com/3108/2773144845_9917365d60_s.jpg"
      end
    end
    
  end
  
  describe "zipping the photos in a photoset" do
    
    before do
      # don't mind if the destination dir doesn't exist, we won't download anything anyway
      File.stub!(:file?).and_return(false)
      @api.stub!(:`).with(/zip -r/)
    end
    
    it "should download the photos" do
      @api.should_receive(:download_photos).with("72157606796637486")
      @api.zipfile("72157606796637486")
    end
    
    it "should zip them together" do
      @api.stub!(:download_photos).and_return([])
      @api.should_receive(:`).with(/zip -r 72157606796637486 72157606796637486/)
      @api.zipfile("72157606796637486")
    end
  end
  
  describe "downloading the photos in a photoset" do
    it "should have specs!"    
  end
  
end

describe Flickr do
  
  describe "Photoset" do
    before { @set = Flickr::Photoset.new("title", "slug", "photo", "description") }
    
    it "should have a title" do
      @set.title.should == "title"
    end
    
    it "should have a slug" do
      @set.slug.should == "slug"
    end
    
    it "should have a photo" do
      @set.photo.should == "photo"
    end
    
    it "should have a description" do
      @set.description.should == "description"
    end
  end
  
  describe "Photo" do
    before { @photo = Flickr::Photo.new("slug", "url", "thumbnail") }
    
    it "should have a slug" do
      @photo.slug.should == "slug"
    end
    
    it "should have a url" do
      @photo.url.should == "url"
    end
    
    it "should have a thumbnail" do
      @photo.thumb.should == "thumbnail"
    end
  end
  
end
