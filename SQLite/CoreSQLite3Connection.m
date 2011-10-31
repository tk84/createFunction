//
//  CoreSQLite3Connection.m
//  SQLite
//
//  Created by Hiroyuki Takahashi on 11/10/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoreSQLite3Connection.h"

@implementation SQLite3Connection (Function)

void __xFunc (sqlite3_context *context, int argc, sqlite3_value **argv)
{
  id pApp = [SQLite3Connection pApp:(NSUInteger)sqlite3_user_data(context) object:NULL];
  id (^block)(id) = [pApp objectForKey:@"block"];

  NSMutableArray *args = [NSMutableArray array];

  int i;
  for (i=0; i<argc; i++) {
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

  id res = block(args);

  [res isKindOfClass:NSClassFromString(@"String")];

  int datatype = [[pApp objectForKey:@"dataType"] intValue];
  if (datatype != SQLITE_INTEGER && datatype != SQLITE_FLOAT && datatype != SQLITE_TEXT && datatype != SQLITE_NULL) {
    //自動判別
    if ([res isKindOfClass:NSClassFromString(@"Integer")]) {
      datatype = SQLITE_INTEGER;
    } else if ( [res isKindOfClass:NSClassFromString(@"Float")] ) {
      datatype = SQLITE_FLOAT;
    } else if ( [res isKindOfClass:NSClassFromString(@"NSString")] ) {
      datatype = SQLITE_TEXT;
    } else {
      datatype = SQLITE_NULL;
    }
  }

  switch ( datatype ) {
    case SQLITE_INTEGER:
      sqlite3_result_int(context, [res intValue]);
      break;
    case SQLITE_FLOAT:
      sqlite3_result_double(context, [res doubleValue]);
      break;
    case SQLITE_TEXT:
      sqlite3_result_text(context, [res UTF8String], (int)[res lengthOfBytesUsingEncoding:NSUTF8StringEncoding], NULL);
      break;
    case SQLITE_NULL:
    default:
      sqlite3_result_null(context);
  }

  [res release];
}

+ (NSMutableDictionary *)pApp:(NSUInteger)i object:(NSMutableDictionary *)pApp
{
  static NSMutableArray *pApps;

  if (NULL == pApps) {
    pApps = [NSMutableArray array];
  }
  
  if (pApp) {
    i = [pApps count];
    [pApp setObject:[NSNumber numberWithUnsignedInteger:i] forKey:@"i"];
    [pApps addObject:pApp];
  }

  return [pApps objectAtIndex:i];
}

- (SQLite3Status)createFunction:(NSString *)name dataType:(int)dataType usingBlock:(id (^)(id)) block;
{
  NSMutableDictionary *pApp = [NSMutableDictionary dictionary];
  [pApp setObject:name forKey:@"name"];
  [pApp setObject:(id)block forKey:@"block"];
  [pApp setObject:[NSNumber numberWithInt:dataType] forKey:@"dataType"];
  NSUInteger i = [[[SQLite3Connection pApp:0 object:pApp] objectForKey:@"i"] unsignedIntegerValue];

  return sqlite3_create_function_v2(connection->db, [name UTF8String], -1, SQLITE_ANY, (void *)i, __xFunc, NULL, NULL, NULL);
}

@end
