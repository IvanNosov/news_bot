#!/usr/bin/env ruby
require_relative '../bot'
while true
  telegram = LozovaNewsBot.new('@tst_lz')
  telegram.sync
  telegram.send
  sleep 300
end

