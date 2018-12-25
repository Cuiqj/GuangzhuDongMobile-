//
//  getCitizen.m
//  GDJZMMobile
//
//  Created by xiaoxiaojia on 16/8/4.
//
//

#import "getCitizen.h"
@implementation getCitizen

-(void)downloadCitizen{
    WebServiceInit;
    [service downloadDataSet:@" select  * from Citizen  where record_create_time >= dateadd(day,-365,GETDATE()) "];
}
//select  * from Citizen  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"Citizen" andInXMLString:webString];
}

@end