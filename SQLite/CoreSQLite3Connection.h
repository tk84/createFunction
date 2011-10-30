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
void __sqlite_function_c(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_d(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_e(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_f(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_g(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_h(sqlite3_context *context, int argc, sqlite3_value **argv);
void __sqlite_function_i(sqlite3_context *context, int argc, sqlite3_value **argv);
- (SQLite3Status)register_function:(NSString *)name usingBlock:(id (^)(id)) block;
- (void) hoge;
@end
