#!/usr/bin/env ruby

def require_tracker_story(commit)
  message = File.read(commit)
  wip_rexexp = Regexp.new('wip', Regexp::IGNORECASE)
  tracker_regexp = /\[(\w+ )?#\d*/
  nostory_flag_regexp = /\[nostory\]/

  is_wip = (message =~ wip_rexexp)
  has_story = (message =~ tracker_regexp)
  has_nostory_flag = (message =~ nostory_flag_regexp)

  if has_nostory_flag
    File.write(commit, message.gsub(nostory_flag_regexp, ''))
    return
  end

  raise "Must include tracker story ID" unless (is_wip) || (has_story)
end

require_tracker_story(ARGV[0])
