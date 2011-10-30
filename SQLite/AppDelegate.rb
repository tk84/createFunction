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


class SQLite3Connection
  def huga
    p 'huga'
  end
end


class AppDelegate
  attr_accessor :window
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application

    File.unlink '/tmp/my.db' if File.file? '/tmp/my.db'

    db = SQLite3Connection.new
    db.initWithPath '/tmp/my.db', flags:KSQLite3OpenCreate | KSQLite3OpenReadWrite

    db.execute 'CREATE TABLE master (id INTEGER, x REAL, c TEXT);'
    db.execute 'INSERT INTO master VALUES (2, 3.5, "unko");'
    db.execute 'INSERT INTO master VALUES (4, 2.3, "ほげ");'


    block = Proc.new {|args|
      arg1,*kipple = *args
      p arg1
    }
    db.createFunction({'name'=>'one_line', 'argc'=>1, 'resultType'=>SQLITE_TEXT}, usingBlock:block);


    block = Proc.new {|args|
      arg1,*kipple = *args
      arg1 + 2
    }
    db.createFunction({'name'=>'plus_two', 'argc'=>1, 'resultType'=>SQLITE_INTEGER}, usingBlock:block);


    block = Proc.new {|args|
      arg1,*kipple = *args
      arg1 / 3.5
    }
    db.createFunction({'name'=>'double_test', 'argc'=>1, 'resultType'=>SQLITE_FLOAT}, usingBlock:block);


    # db.create_function_strict 'one_line', usingBlock:Proc.new {|args|
    #   value,*kipple = *args
    #   p value
    # }

    # db.register_function 'one_line', usingBlock:Proc.new {|args|
    #   puts args
    #   'nano'
    # }

    db.enumerateWithQuery 'SELECT plus_two(id), double_test(x), one_line(c) FROM master;', usingBlock:Proc.new {|row, stop|
      p row
    }


  end
end

