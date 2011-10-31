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
  def prepare
    p 'huga'
  end

  def query sql, bindings=nil, &p
    stmt = statementWithQuery sql
    stmt.bindWithDictionary bindings if bindings
    if p
      while SQLITE_ROW == stmt.step
        row = []
        stmt.columnCount.times do |i|
          row.push stmt.objectWithColumn(i)
        end
        p.call row
      end
      stmt.reset
    end
    stmt
  end
end

class AppDelegate
  attr_accessor :window
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application

    p "5".class.ancestors
    p 5.class.ancestors
    p 5.5.class.ancestors
    return
    
    #    File.unlink '/tmp/my.db' if File.file? '/tmp/my.db'

    db = SQLite3Connection.new
    db.initWithPath '/tmp/my.db', flags:KSQLite3OpenCreate | KSQLite3OpenReadWrite

    # db.execute 'CREATE TABLE master (id INTEGER, x REAL, c TEXT);'
    # db.execute 'INSERT INTO master VALUES (2, 3.5, "unko");'
    # db.execute 'INSERT INTO master VALUES (4, 2.3, "ほげ");'

    # db.execute('INSERT INTO master VALUES (:int, :double, :text);',
    #    withDictionaryBindings:{'int'=>7878, 'double'=>8.92384, 'text'=>'oijioewiojiewr'})


    # db.createFunction({'name'=>'one_line', 'argc'=>1, 'resultType'=>SQLITE_TEXT},
    #    usingBlock:Proc.new {|args|
    #                     text,*kipple = *args
    #                     text + 'hoge'
    #                   })

    # db.createFunction({'name'=>'plus_two', 'argc'=>1, 'resultType'=>SQLITE_INTEGER},
    #    usingBlock:Proc.new {|args|
    #                     arg1,*kipple = *args
    #                     arg1 + 2
    #                   });


    # db.createFunction({'name'=>'double_test', 'argc'=>1, 'resultType'=>SQLITE_FLOAT},
    #    usingBlock:Proc.new {|args|
    #                     arg1,*kipple = *args
    #                     arg1 / 3.5
    #                   });

    # db.enumerateWithQuery 'SELECT plus_two(id) AS two, double_test(x) AS dtest, one_line(c) AS oneline FROM master;', usingBlock:Proc.new {|row, stop|
    #   p row
    # }

    # db.query 'SELECT plus_two(id) AS two, double_test(x) AS dtest, one_line(c) AS oneline FROM master;' do |row|
    #   p row
    # end




    db.createFunction 'oneline', dataType:SQLITE_TEXT, usingBlock:Proc.new{|args|
                      args[0].
                      # gsub(/(<[^>]*>|\s)/, ' ').
                      gsub(/\s+/, ' ').
                      gsub(/(^\s|\s$)/, '')
                      }

    db.createFunction('ftime_to_srtime', dataType:SQLITE_TEXT, usingBlock:Proc.new{|args|
                         ftime,*kipple = *args
                         h = ftime / 3600
                         ftime %= 3600
                         m = ftime / 60
                         ftime %= 60
                         s = ftime
                         ftime -= ftime.truncate
                         '%02d:%02d:%02d,%03d' % [h,m,s,(ftime*1000)]
                       })

    
    #db.enumerateWithQuery 'SELECT ftime_to_srtime(begin_time), ftime_to_srtime(end_time), oneline(caption) FROM master;', usingBlock:Proc.new {|row, stop|
    #p row
    #}

    db.query 'SELECT ftime_to_srtime(begin_time), ftime_to_srtime(end_time), oneline(caption) FROM master;' do |row|
      #p row
    end

    p 'unkounko'

  end
end

