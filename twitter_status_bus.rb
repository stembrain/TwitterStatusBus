#!/usr/bin/env ruby
#
# Update iChat/Adium status from Twitter
#
# Michael Tyson 
# http://michael.tyson.id.au

# Set Twitter username here
Username = 'stembrain'

require 'net/http'
require 'rexml/document'

# Download timeline XML and extract latest entry
url = "http://twitter.com/statuses/user_timeline/" + Username + ".atom"
xml_data = Net::HTTP.get_response(URI.parse(url)).body
doc    = REXML::Document.new(xml_data)
latest = doc.root.elements['entry/content']
message = latest.text.gsub(/^[^:]+:\s*/, '')
#date = doc.root.elements['*//*[@class=\'lastUpdate\']']
#date = '<lastBuildDate>' + date + '</lastBuildDate>'
date = ''
statusFeed = '<?xml version="1.0" encoding="utf-8"?>

<rss version="2.0">

  <channel>'
    '<item>
      <title>What\'s up with David </title>
      <description>' + message + ' </description>
    </item>
  </channel>
</rss>'
File.open('/Users/demann/Sites/ENNCF/ENNCF/stembrain.atom', 'w') {|f| f.write(statusFeed) }

exit if ! message

# Apply to status
script = 'set message to "' + message.gsub(/"/, '\\"') + "\"\n" +
         'tell application "System Events"' + "\n" +
         'if exists process "iChat" then tell application "iChat" to set the status message to message' + "\n" +
         'if exists process "Adium" then tell application "Adium" to set status message of every account to message' + "\n" +
         'end tell' + "\n"

#IO.popen("osascript", "w") { |f| f.puts(script) }
