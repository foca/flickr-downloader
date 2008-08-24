$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib", *Dir["#{File.dirname(__FILE__)}/vendor/**/lib"].to_a
require "flickr"
require "yaml"
require "rubygems"
require "sinatra"

configure do
  CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/config/config.yml")
end

use_in_file_templates!

get "/" do
  haml :home
end

get "/:id.zip" do
  send_file flickr.zipfile(params[:id])
  redirect "/"
end

get "/status/:id" do
  throw :halt, File.file?(File.join(downloads_dir, "#{params[:id]}.zip")) ? 200 : 404
end

get "/styles.css" do
  content_type "text/css; charset=utf-8"
  sass :styles
end

helpers do
  def flickr
    @flickr ||= Flickr.new(CONFIG[:api_key], CONFIG[:user_id], downloads_dir)
  end
  
  def downloads_dir
    File.join(File.dirname(__FILE__), "public")
  end
  
  def cycle(*values)
    @cycles ||= {}
    @cycles[values] ||= -1 # first value returned is 0
    next_value = @cycles[values] = (@cycles[values] + 1) % values.size
    values[next_value]
  end
end

__END__

@@home
%h1 my flickr sets
%ul
  - flickr.photosets.each do |set|
    %li{ :class => cycle("even", "odd") }
      %h2= escape_once set.title
      %p
        %img{ :src => set.photo.thumb, :alt => set.title }
        %a{ :href => "/#{set.slug}.zip" } Download Zip

@@layout
!!! Strict
%html{ html_attrs }
  %head
    %meta{ :"http-equiv" => "Content-Type", :content => "text/html; charset=utf-8" }
    %title Flickr Downloader!
    %link{ :href => "/reset.css", :type => "text/css", :rel => "stylesheet" }
    %link{ :href => "/styles.css", :type => "text/css", :rel => "stylesheet" }
  %body
    #content
      = yield
    %address#footer
      By <a href="http://nicolassanguinetti.info">Nicolás Sanguinetti</a>
    %script{ :src => "/prototype-1.6.0.2.js", :type => "text/javascript" }
    %script{ :src => "/polling.js", :type => "text/javascript" }

@@styles
body
  :background #eee
  :font
    :family "Helvetica Neue", Helvetica, Arial, sans-serif
  :color #333

#content, #footer
  :width 384px
  :margin-left 64px
  :border
    :left 1px solid #ccc
    :right 1px solid #ccc
  :padding 16px 0
  :background #fff

#footer
  :padding 7px 0
  :text-align center
  :color #ccc
  :font-size 12px
  a
    :color #bbb
    &:hover
      :color #aaa

h1
  :margin-bottom 16px
  :text-align center
  :font
    :size 32px
    :weight bold
    :family Georgia, "Times New Roman", serif

ul
  :border-bottom 1px solid #ccc
  li
    :height 75px
    :list-style-type none
    :clear left
    :border
      :style solid
      :width 1px 0 0
      :color #ccc
    :position relative
    &.even
      :background #f8f8f8
    &:hover
      :background #ffc
      a
        :color #f33
    &.downloading
      :background #ffc url(/loader.gif) no-repeat 98% 98%
    h2
      :position absolute
      :left 80px
      :top 3px
      :font-size 1.5em
      :font-weight bold
      :line-height 1
    img
      :position absolute
      :left 0
      :top 0
    a
      :display block
      :position absolute
      :left 0
      :bottom 0
      :z-index 1
      :height 16px
      :width 100%
      :padding
        :bottom 3px
        :top 56px
      :text-indent 80px
      :font-size 12px
      :color #83bf09
