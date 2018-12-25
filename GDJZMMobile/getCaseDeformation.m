//
//  getCaseDeformation.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseDeformation.h"
@implementation getCaseDeformation

-(void)downLoadCaseDeformation{
    WebServiceInit;
    [service downloadDataSet:@" select  * from CaseDeformation  where record_create_time >= dateadd(day,-365,GETDATE()) "];
}
//select  * from CaseDeformation  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseDeformation" andInXMLString:webString];
}

@end