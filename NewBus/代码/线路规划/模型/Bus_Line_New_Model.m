//
//  Bus_Line_New_Model.m
//  NewsBus
//
//  Created by WithLove on 2018/11/20.
//  Copyright © 2018 WithLove. All rights reserved.
//

#import "Bus_Line_New_Model.h"
#import "Bus_New_Record.h"

static Bus_Line_New_Model *_defaulthandle = nil;

@interface Bus_Line_New_Model()

@property(nonatomic,strong)FMDatabase *fMDB;  //

@end

@implementation Bus_Line_New_Model

+(Bus_Line_New_Model *)sharedDataHandle
{
    if (_defaulthandle == nil) {
        _defaulthandle = [[Bus_Line_New_Model alloc] init];
        
    }
    return _defaulthandle;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_defaulthandle == nil) {
        _defaulthandle = [super allocWithZone:zone];
    }
    return _defaulthandle;
}


-(FMDatabase *)fMDB
{
    if (!_fMDB) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shouCang.sqlite"];
//        NSLog(@"---------------------\n%@\n-----------------",path);
        _fMDB = [FMDatabase databaseWithPath:path];
        [self initTable];
    }
    return _fMDB;
}


// 初始化数据表
-(void)initTable
{
    [_fMDB open];
    
    [_fMDB executeUpdate:@"CREATE TABLE shouCang (id INTEGER PRIMARY KEY AUTOINCREMENT,start TEXT,end TEXT,time TEXT)"];
    
    
    [_fMDB close];
}



-(void)addOneMovie:(Bus_New_Record *)movie
{
    [self.fMDB open];
    
    // [self.fMDB executeUpdate:@"insert into movie (name,actor,date,price) values(?,?,?,?)",movie.name,movie.actor ,movie.date ,movie.price];
    
    [self.fMDB executeUpdateWithFormat:@"insert into shouCang (start,end,time) values(%@,%@,%@)",movie.start,movie.end ,movie.time];
    
    [self.fMDB close];
}

-(void)deleteMovieByID:(int)delID
{
    [self.fMDB open];
    
    // [self.fMDB executeUpdate:@"DELETE FROM movie WHERE id = ?",delID];
    
    [self.fMDB executeUpdateWithFormat:@"DELETE FROM shouCang WHERE id = %d",delID];
    
    [self.fMDB close];
}

-(NSArray *)getAllMovies
{
    [self.fMDB open];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [self.fMDB executeQuery:@"SELECT * FROM shouCang"];
    while ([result next])
    {
        Bus_New_Record *movie = [[Bus_New_Record alloc] init];
        [arr addObject:movie];
        
        movie.recordID = [result intForColumnIndex:0];
        movie.start = [result stringForColumnIndex:1];
        movie.end = [result stringForColumnIndex:2];
        movie.time = [result stringForColumnIndex:3];
    }
    [self.fMDB close];
    
    return [arr copy];
}



@end
