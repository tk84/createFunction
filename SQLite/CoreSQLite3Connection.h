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
void __xFunc(sqlite3_context *context, int argc, sqlite3_value **argv);
- (void) hoge;
- (SQLite3Status)createFunction:(NSDictionary *)pApp usingBlock:(id (^)(id)) block;
@end
