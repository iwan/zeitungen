# require "zeitung/version"
# require "zeitung/dropbox_client"
# require "zeitung/file_client"
# require "zeitung/zeitung"
# require "zeitung/index_page"
# require "zeitung/downloader"
# require "zeitung/password"
# require "zeitung/passwords"

%w(
  version
  zeitung
  dropbox_client
  file_client
  index_page
  downloader
  password
  passwords
).each { |file| require File.join(File.dirname(__FILE__), 'zeitung', file) }


module Zeitung
  # Your code goes here...
end
