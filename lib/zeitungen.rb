# require "zeitungen/version"
# require "zeitungen/dropbox_client"
# require "zeitungen/file_client"
# require "zeitungen/zeitungen"
# require "zeitungen/index_page"
# require "zeitungen/downloader"
# require "zeitungen/password"
# require "zeitungen/passwords"

%w(
  version
  zeitungen
  dropbox_client
  file_client
  index_page
  downloader
  password
  passwords
).each { |file| require File.join(File.dirname(__FILE__), 'zeitungen', file) }

include Zeitungen
# module Zeitung
#   # Your code goes here...
# end
