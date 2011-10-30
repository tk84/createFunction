//
//  CoreSQLite3Connection.m
//  SQLite
//
//  Created by Hiroyuki Takahashi on 11/10/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoreSQLite3Connection.h"

@implementation SQLite3Connection (Function)
id function_map;

void __sqlite_function_a(sqlite3_context *context, int argc, sqlite3_value **argv)
{
  id (^block)(id) = [function_map objectAtIndex:0];

  NSMutableArray * ary = [NSMutableArray array];
  [ary addObject:@"zero"];
  [ary addObject:@"one"];
  [ary addObject:@"two"];

  NSString * pApp = sqlite3_user_data(context);
  NSLog(@"%@", pApp);
  
  block(ary);

//  if (argc == 1 && sqlite3_value_type(argv[0]) != SQLITE_NULL) {
//    sqlite3_result_double(context, sin(sqlite3_value_double(argv[0])));
//  } else {
//    sqlite3_result_null(context);
//  }
}

void __sqlite_function_b(sqlite3_context *context, int argc, sqlite3_value **argv)
{
  
}

- (SQLite3Status)register_function:(NSString *)name usingBlock:(id (^)(id)) block
{
  if (NULL == function_map) {
    function_map = [NSMutableArray array];
  }

  [function_map addObject:block];

//  void (*pfunc[2])() = {__sqlite_function_a, __sqlite_function_b};

  NSMutableArray *func = [NSMutableArray array];
  [func addObject:(id)__sqlite_function_a];
  
  SQLite3ConnectionRegisterFunction(connection, (CFStringRef)name, 1, (void(*)(sqlite3_context *, int, sqlite3_value **))[func objectAtIndex:0]);
  
  return kSQLite3StatusOK;
}

- (void) hoge
{
  NSLog(@"hoge");
  
  
  
}
@end
