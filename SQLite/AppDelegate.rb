# -*- coding: utf-8 -*-
#
#  AppDelegate.rb
#  SQLite
#
#  Created by Hiroyuki Takahashi on 11/10/30.
#  Copyright 2011年 __MyCompanyName__. All rights reserved.
#

load_bridge_support_file '/Volumes/Data/Users/hiro/Documents/Xcode/lib/CoreSQLite3.framework/Versions/A/Resources/BridgeSupport/CoreSQLite3.bridgesupport'
load_bridge_support_file '/Volumes/Data/Users/hiro/Documents/Xcode/SQLite/SQLite/bs'

class AppDelegate
  attr_accessor :window
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application

    File.unlink '/tmp/my.db' if File.file? '/tmp/my.db'

    db = SQLite3Connection.new
    db.initWithPath '/tmp/my.db', flags:KSQLite3OpenCreate | KSQLite3OpenReadWrite

    db.execute 'CREATE TABLE master (id INTEGER, x REAL);'
    db.execute 'INSERT INTO master VALUES (2, 3.5);'
    db.execute 'INSERT INTO master VALUES (4, 2.3);'

    p Proc.ancestors

    db.register_function 'one_line', usingBlock:Proc.new {|args|
      puts args
      'nano'
    }

    db.enumerateWithQuery 'SELECT one_line(x), id FROM master;', usingBlock:Proc.new {|row, stop|
      p row
    }

    db.hoge

  end
end

