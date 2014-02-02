#!/usr/bin/env ruby

require 'gmail-britta'

if File.exist?(File.join(File.dirname(__FILE__), 'alexmuller-private.rb'))
  require_relative 'alexmuller-private'
else
  MY_EMAIL_ADDRESSES = %w[alexmuller@gds]
  GDS_SECOND_LINE = '2ndline@gds'
  GDS_GHE = 'ghe@gds'
end

PUBLIC_REPOS_I_CARE_ABOUT = File.read(File.join(File.dirname(__FILE__), './github-repos-i-care-about.txt')).gsub("\n", ' ')
PRIVATE_REPOS_I_CARE_ABOUT = File.read(File.join(File.dirname(__FILE__), './github-enterprise-repos-i-care-about.txt')).gsub("\n", ' ')

puts(GmailBritta.filterset(:me => MY_EMAIL_ADDRESSES) do

  filter {
    has [GDS_SECOND_LINE]
    label '2nd-line'
  }

  filter {
    has ['from:pagerduty.com']
    mark_important
  }

  filter {
    has ['subject:cake']
    mark_important
  }

  filter {
    has ['from:pivotaltracker.com', 'subject:(NEW COMMENT)', '"Commit by"']
    label 'autoarchive-pivotal'
    mark_read
    archive
  }

  filter {
    has ['from:notifications@github.com', "-{#{PUBLIC_REPOS_I_CARE_ABOUT}}"]
    label 'autoarchive-github-notifications'
    mark_read
    never_spam
  }.archive_unless_directed

  filter {
    has ["from:#{GDS_GHE}", "-{#{PRIVATE_REPOS_I_CARE_ABOUT}}"]
    label 'autoarchive-github-notifications'
    mark_read
    never_spam
  }.archive_unless_directed

end.generate)
