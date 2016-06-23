require 'net/http'
require 'date'
require 'open-uri'
require 'fileutils'
require 'mechanize'
require 'tempfile'
require 'dropbox_sdk'
require 'http'


%w(
  version
  zeitung
  dropbox_client
  file_client
  index_page
  downloader
  password
  passwords
).each { |file| require File.join(File.dirname(__FILE__), 'zeitungen', file) }

include Zeitungen
