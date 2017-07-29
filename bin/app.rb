#!/usr/bin/env ruby
require_relative '../bot'

telegram = LozovaNewsBot.new('http://lozovarada.gov.ua/golovni-novini.html', '@tst_lz')
telegram.sync
telegram.send


