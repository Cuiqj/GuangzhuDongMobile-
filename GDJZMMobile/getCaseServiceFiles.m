//
//  getCaseServiceFiles.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseServiceFiles.h"
@implementation getCaseServiceFiles

-(void)downLoadCaseServiceFiles{
    WebServiceInit;
    [service downloadDataSet:@"select  * from CaseServiceFiles  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseServiceFiles  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseServiceFiles" andInXMLString:webString];
}

@end