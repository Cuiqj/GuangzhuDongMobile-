//
//  getParkingNode.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getParkingNode.h"
@implementation getParkingNode

-(void)downLoadParkingNode{
    WebServiceInit;
    [service downloadDataSet:@" select  * from ParkingNode  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from ParkingNode  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"ParkingNode" andInXMLString:webString];
}

@end