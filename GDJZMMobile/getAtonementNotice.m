//
//  getAtonementNotice.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getAtonementNotice.h"
@implementation getAtonementNotice

-(void)downLoadAtonementNotice{
    NSLog(@"下载%@ biao",@"AtonementNotice");
    WebServiceInit;
    [service downloadDataSet:@" select  * from AtonementNotice  where record_create_time >= dateadd(day,-365,GETDATE()) "];
}
//select  * from AtonementNotice  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"AtonementNotice" andInXMLString:webString];
}

@end