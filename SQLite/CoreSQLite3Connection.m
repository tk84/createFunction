//
//  CoreSQLite3Connection.m
//  SQLite
//
//  Created by Hiroyuki Takahashi on 11/10/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CoreSQLite3Connection.h"

@implementation SQLite3Connection (Function)

id hoge;
void __xFunc (sqlite3_context *context, int argc, sqlite3_value **argv)
{
//  id (^block)(id) = [hoge objectForKey:@"block"];
//  id (^block)(id) = sqlite3_user_data(context);
  
//  id pApp = sqlite3_user_data(context);

  id pApp = [SQLite3Connection pApp:(NSUInteger)sqlite3_user_data(context) object:NULL];
//  id pApp = [hoge objectAtIndex:(NSUInteger)sqlite3_user_data(context)];

//  NSLog(@"%@", pApp);
//  NSLog(@"%@", [pApp objectForKey:@"block"]);

//  NSLog(@"%@", [pApp objectForKey:@"name"]);
  
  id (^block)(id) = [pApp objectForKey:@"block"];

//  id (^block)(id) = hoge;

  
//  return;
//  id (^block)(id) = [pApp objectForKey:@"block"];

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
 
  NSString *str;
  switch ([[pApp objectForKey:@"resultType"] intValue]) {
    case SQLITE_INTEGER:
      sqlite3_result_int(context, [block(args) intValue]);
      break;
    case SQLITE_FLOAT:
      sqlite3_result_double(context, [block(args) doubleValue]);
      break;
    case SQLITE_TEXT:
      str = block(args);
//      NSLog(@"%d", (int)[str length]);
      sqlite3_result_text(context, [str UTF8String], (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], NULL);
      [str release];
      break;
    default:
      sqlite3_result_null(context);
  }
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

- (SQLite3Status)createFunction:(NSMutableDictionary *)pApp usingBlock:(id (^)(id))block
{
  SQLite3Status status = kSQLite3StatusError;

  __SQLite3UTF8String utf8Name = __SQLite3UTF8StringMake(connection->allocator, (CFStringRef)[pApp objectForKey:@"name"]);

  [pApp setObject:(id)block forKey:@"block"];
  NSUInteger i = [[[SQLite3Connection pApp:0 object:pApp] objectForKey:@"i"] unsignedIntegerValue];

  if (NULL == hoge) {
    hoge = [NSMutableArray array];
  }
  [hoge addObject:pApp];
  
  status = sqlite3_create_function_v2(connection->db, __SQLite3UTF8StringGetBuffer(utf8Name), [[pApp objectForKey:@"argc"] intValue], SQLITE_ANY, /*(void *)block*/(void *)i/*([hoge count] - 1)*/, __xFunc, NULL, NULL, NULL);
  __SQLite3UTF8StringDestroy(utf8Name);
   
  return status;  
}

- (void) hoge
{
  NSLog(@"%@", 1);
}
@end
