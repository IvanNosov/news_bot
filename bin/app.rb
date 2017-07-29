#!/usr/bin/env ruby
require_relative '../bot'

telegram = LozovaNewsBot.new('@tst_lz')
telegram.sync
telegram.send


