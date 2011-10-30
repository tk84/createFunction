//
//  CoreSQLite3Connection.h
//  SQLite
//
//  Created by Hiroyuki Takahashi on 11/10/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLite3Connection.h"

@interface SQLite3Connection (Function)
void __sqlite_function_a(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_b(sqlite3_context *context, int argc, sqlite3_value **argv);
void __xFunc(sqlite3_context *context, int argc, sqlite3_value **argv);
SQLite3Status CoreSQLite3ConnectionRegisterFunction(SQLite3ConnectionRef connection, CFStringRef name, CFIndex argc, void (*f)(sqlite3_context *, int, sqlite3_value **));
- (SQLite3Status)register_function:(NSString *)name usingBlock:(id (^)(id)) block;
- (void) hoge;
- (SQLite3Status)create_function_strict:(NSString *)name usingBlock:(id (^)(id)) block;
@end
