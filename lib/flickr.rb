%w(fileutils open-uri thread rubygems).each &method(:require)
require "hpricot"

class Flickr
  Photoset = Struct.new(:title, :slug, :photo, :description)
  Photo    = Struct.new(:slug, :url, :thumb)
  
  def initialize(api_key, user_id, storage_dir)
    @api_key, @user_id, @storage_dir = api_key, user_id, storage_dir
  end
  
  def photosets
    get("flickr.photosets.getList").search(:photoset).pmap do |set|
      Photoset.new(set.at(:title).inner_html,
                   set["id"],
                   photo(set["primary"]),
                   set.at(:description).inner_html)
    end
  end
  
  def photos_in_set(id)
    get("flickr.photosets.getPhotos", :photoset_id => id).search(:photo).pmap do |data|
      photo data["id"]
    end
  end
  
  def photo(id)
    original = thumbnail = nil
    get("flickr.photos.getSizes", :photo_id => id).search(:size).each do |size| 
      original  = size["source"] if size["label"] == "Original"
      thumbnail = size["source"] if size["label"] == "Square"
    end
    Photo.new(id, original, thumbnail)
  end
  
  def zipfile(photoset_id)
    download_photos(photoset_id)
    `cd #{@storage_dir} && zip -r #{photoset_id} #{photoset_id}`
    File.join(@storage_dir, photoset_id.to_s + ".zip")
  end
  
  private
  
    def download_photos(photoset_id)
      FileUtils.mkdir_p File.join(@storage_dir, photoset_id)
      photos_in_set(photoset_id).pmap do |photo|
        File.join(@storage_dir, photoset_id, photo.slug.to_s + File.extname(photo.url)).tap do |path|
          `curl #{photo.url} >#{path} 2>/dev/null`
        end
      end
    end
  
    def get(method, query={})
      Hpricot::XML open(url(query.merge(:method => method)))
    end
    
    def url(request={})
      request = { :api_key => @api_key, :user_id => @user_id }.merge(request).to_query_string
      "http://api.flickr.com/services/rest/?#{request}"
    end
end

class Hash
  def to_query_string
    inject(nil) do |query, (key,val)|
      [query, "#{key}=#{val}"].compact.join("&")
    end
  end
end

class Array
  # taken from project.ioni.st
  def pmap
    mapped_array = []
    threads      = []
    0.upto(size - 1) do |n|
      threads << Thread.new do
        mapped_array[n] = yield(at(n))
      end
    end
    threads.each {|thread| thread.join}
    mapped_array
  end
end

class Hpricot::Elements
  def pmap(&block)
    to_a.pmap(&block)
  end
end

class Object
  def tap
    yield self
    self
  end
end
