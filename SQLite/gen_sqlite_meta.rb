#!/usr/bin/env ruby

require '~/lib/MyFunction'

Dir::chdir File.dirname(__FILE__)

file = "#{Tk84::MyFunction.uniqid}.h"
File.open file, 'w' do |f|
  f.write File.read("CoreSQLite3Connection.h").sub(/\(Function\)/, '')
end

`gen_bridge_metadata --64-bit -c '-I.' #{file} -o bs`

File.unlink file
