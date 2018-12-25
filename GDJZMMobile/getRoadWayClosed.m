//
//  getRoadWayClosed.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getRoadWayClosed.h"
@implementation getRoadWayClosed

-(void)downLoadRoadWayClosed{
    WebServiceInit;
    [service downloadDataSet:@" select  * from RoadWayClosed  where record_create_time >= dateadd(day,-365,GETDATE()) "];
}
//select  * from RoadWayClosed  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"RoadWayClosed" andInXMLString:webString];
}

@end