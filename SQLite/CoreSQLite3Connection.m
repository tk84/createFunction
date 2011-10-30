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

SQLite3Status CoreSQLite3ConnectionRegisterFunction(SQLite3ConnectionRef connection, CFStringRef name, CFIndex argc, void (*f)(sqlite3_context *, int, sqlite3_value **)) {
  SQLite3Status status = kSQLite3StatusError;
  if (connection) {
    if (name) {
      __SQLite3UTF8String utf8Name = __SQLite3UTF8StringMake(connection->allocator, name);
      status = sqlite3_create_function_v2(connection->db, __SQLite3UTF8StringGetBuffer(utf8Name), (int)argc, SQLITE_ANY, (void *)name, f, NULL, NULL, NULL);
      __SQLite3UTF8StringDestroy(utf8Name);
    }
  }
  return status;
}

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
  id (^block)(id) = sqlite3_user_data(context);

  NSMutableArray *args = [NSMutableArray array];
  int i;
  for (i=0; i<argc; i++) {
    //type = sqlite3_value_type(argv[i]);
    switch (sqlite3_value_type(argv[i])) {
      case SQLITE_INTEGER:
        [args addObject:[NSNumber numberWithInt:sqlite3_value_int(argv[i])]];
        break;
      case SQLITE_FLOAT:
        [args addObject:[NSNumber numberWithDouble:sqlite3_value_double(argv[i])]];
        break;
      case SQLITE_BLOB:
        break;
      case SQLITE_TEXT:
        [args addObject:[NSString stringWithUTF8String:(const char *)sqlite3_value_text(argv[i])]];
        break;
      case SQLITE_NULL:
      default:
        [args addObject:NULL];
        break;
    };
  }
  

  id result =  block(args);

  sqlite3_result_int(context, 3);
}

void __xFunc (sqlite3_context *context, int argc, sqlite3_value **argv)
{
  id (^block)(id) = sqlite3_user_data(context);
  
  NSMutableArray *args = [NSMutableArray array];
  int i;
  for (i=0; i<argc; i++) {
    //type = sqlite3_value_type(argv[i]);
    switch (sqlite3_value_type(argv[i])) {
      case SQLITE_INTEGER:
        [args addObject:[NSNumber numberWithInt:sqlite3_value_int(argv[i])]];
        break;
      case SQLITE_FLOAT:
        [args addObject:[NSNumber numberWithDouble:sqlite3_value_double(argv[i])]];
        break;
      case SQLITE_BLOB:
        break;
      case SQLITE_TEXT:
        [args addObject:[NSString stringWithUTF8String:(const char *)sqlite3_value_text(argv[i])]];
        break;
      case SQLITE_NULL:
      default:
        [args addObject:NULL];
        break;
    };
  }
  
  
  id result =  block(args);
  
  sqlite3_result_int(context, 3);
}


- (SQLite3Status)create_function_strict:(NSString *)name usingBlock:(id (^)(id)) block
{
  SQLite3Status status = kSQLite3StatusError;
  int argc = 1;

  __SQLite3UTF8String utf8Name = __SQLite3UTF8StringMake(connection->allocator, (CFStringRef)name);
  status = sqlite3_create_function_v2(connection->db, __SQLite3UTF8StringGetBuffer(utf8Name), (int)argc, SQLITE_ANY, (void *)block, __sqlite_function_b, NULL, NULL, NULL);
  __SQLite3UTF8StringDestroy(utf8Name);

  return status;  
}

- (SQLite3Status)register_function:(NSString *)name usingBlock:(id (^)(id)) block
{
  if (NULL == function_map) {
    function_map = [NSMutableArray array];
  }

  [function_map addObject:block];

  NSMutableArray *func = [NSMutableArray array];
  [func addObject:(id)__sqlite_function_a];
  
  SQLite3ConnectionRegisterFunction(connection, (CFStringRef)name, 1, (void(*)(sqlite3_context *, int, sqlite3_value **))[func objectAtIndex:0]);
  
  return kSQLite3StatusOK;
}

- (void) hoge
{
  NSLog(@"%@", 1);
}
@end
