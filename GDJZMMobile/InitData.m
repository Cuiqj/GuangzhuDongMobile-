//
//  InitData.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-10-9.
//
//

#import "InitData.h"

@implementation InitData

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    [self xmlParser:webString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParserFinished" object:nil userInfo:nil];
}

- (void)autoParserForDataModel:(NSString *)dataModelName andInXMLString:(NSString *)xmlString{
    [[AppDelegate App] clearEntityForName:dataModelName];
      NSLog(@"下载 %@ 表 in autoParserForDataModel",dataModelName);
//    NSLog(@"下载 %@ 表 :%@ in autoParserForDataModel",dataModelName,xmlString);
    if ([dataModelName isEqualToString:@"Systype"]) {
        NSLog(@"Synchronizing data model Systype");
    }
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    if (!error) {
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
        TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
        TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
        TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
        
        TBXMLElement *table=r4->firstChild;
        while (table) {
            @autoreleasepool {
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:dataModelName inManagedObjectContext:context];
                id obj = [[NSClassFromString(dataModelName) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                TBXMLElement *tableChild = table->firstChild;
                //下载案件的历史数据  不能编辑  所以下载的时候处理一下  标记为已上传过的
                //[obj setValue:@(YES) forKey:@"isuploaded"];
                while (tableChild) {
                    @autoreleasepool {
                        NSString *elementName = [[TBXML elementName:tableChild] lowercaseString];
                        if ([elementName isEqualToString:@"id"]) {
                            elementName = @"myid";
                        }
                        // NSString *strBxx = [NSString stringWithFormat:@"CaseInfo"];
                        //if(strBxx==dataModelName){
                                  NSLog(@"key: %@ value: %@",elementName,[TBXML textForElement:tableChild]);
                        // }
                        if ([obj respondsToSelector:NSSelectorFromString(elementName)]) {
                            NSDictionary *attributes = [entity attributesByName];
                            NSAttributeDescription *attriDesc = [attributes objectForKey:elementName];
//                            id testvalue = [TBXML textForElement:tableChild];
//                            if ([testvalue isEqualToString:@"过站状态"]) {
//                                NSLog(@"过站状态");
//                            }
                            switch (attriDesc.attributeType) {
                                case NSStringAttributeType:
                                    [obj setValue:[TBXML textForElement:tableChild] forKey:elementName];
                                    break;
                                case NSBooleanAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].boolValue) forKey:elementName];
                                    break;
                                case NSFloatAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].floatValue) forKey:elementName];
                                    break;
                                case NSDoubleAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].doubleValue) forKey:elementName];
                                    break;
                                case NSDateAttributeType:{
                                    NSString *dateString = [TBXML textForElement:tableChild];
                                    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmss'.'SSSSSSSZ"];
                                    [obj setValue:[dateFormatter dateFromString:dateString] forKey:elementName];
                                }
                                    break;
                                case NSInteger16AttributeType:
                                case NSInteger32AttributeType:
                                case NSInteger64AttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].integerValue) forKey:elementName];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                    tableChild = tableChild->nextSibling;
                }
                [[AppDelegate App] saveContext];
                table = table->nextSibling;
            }
        }
    }
}

- (void)autoParserForOldDataModel:(NSString *)dataModelName andInXMLString:(NSString *)xmlString{
    NSLog(@"下载 %@ 表 :%@ in autoParserForOldDataModel",dataModelName,xmlString);
    //  NSLog(@"下载 %@ 表 in autoParserForOldDataModel",dataModelName);
    [[AppDelegate App] clearEntityForName:dataModelName];
    if ([dataModelName isEqualToString:@"Systype"]) {
        NSLog(@"Synchronizing data model Systype");
    }
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    if (!error) {
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
        TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
        TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
        TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
       
        TBXMLElement *table=NULL;
        if(r4){
        table=r4->firstChild;
         }
        else{
             table=NULL;
         }
//        TBXMLElement *table=r4->firstChild;
        while (table) {
            @autoreleasepool {
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:dataModelName inManagedObjectContext:context];
                id obj = [[NSClassFromString(dataModelName) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                TBXMLElement *tableChild = table->firstChild;
                //下载案件的历史数据  不能编辑  所以下载的时候处理一下  标记为已上传过的
                 [obj setValue:@(YES) forKey:@"isuploaded"];
                while (tableChild) {
                    @autoreleasepool {
                        NSString *elementName = [[TBXML elementName:tableChild] lowercaseString];
                        if ([elementName isEqualToString:@"id"]) {
                            elementName = @"myid";
                        }
                        //NSString *strBxx = [NSString stringWithFormat:@"CaseInfo"];
                        //if(strBxx==dataModelName){
                        //NSLog(@"key: %@ value: %@",elementName,[TBXML textForElement:tableChild]);
                        //}
                      NSLog(@"key: %@ value: %@ ",elementName,[TBXML textForElement:tableChild]);
                        if ([obj respondsToSelector:NSSelectorFromString(elementName)]) {
                            NSDictionary *attributes = [entity attributesByName];
                            NSAttributeDescription *attriDesc = [attributes objectForKey:elementName];
                            //                            id testvalue = [TBXML textForElement:tableChild];
                            //                            if ([testvalue isEqualToString:@"过站状态"]) {
                            //                                NSLog(@"过站状态");
                            //                            }
                            switch (attriDesc.attributeType) {
                                case NSStringAttributeType:
                                    [obj setValue:[TBXML textForElement:tableChild] forKey:elementName];
                                    break;
                                case NSBooleanAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].boolValue) forKey:elementName];
                                    break;
                                case NSFloatAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].floatValue) forKey:elementName];
                                    break;
                                case NSDoubleAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].doubleValue) forKey:elementName];
                                    break;
                                case NSDateAttributeType:{
                                    
                                    NSString *dateString = [TBXML textForElement:tableChild];
                                    // dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
                                    
                                    dateString = [dateString substringWithRange:NSMakeRange(0, 19)];
                                    NSLog(@"%@ : %@ 是时间 转换后",elementName,dateString);
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSSSSSZ"];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                    [obj setValue:[dateFormatter dateFromString:dateString] forKey:elementName];
                                    
//                                    NSDate  *ocdate=[dateFormatter dateFromString:dateString];
//                                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                    NSLog( @"解析后的： %@ ",[dateFormatter stringFromDate:ocdate]);
                                }
                                    break;
                                case NSInteger16AttributeType:
                                case NSInteger32AttributeType:
                                case NSInteger64AttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].integerValue) forKey:elementName];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                    tableChild = tableChild->nextSibling;
                }
                [[AppDelegate App] saveContext];
                table = table->nextSibling;
            }
        }
    }
}

- (void)xmlParser:(NSString *)webString{};

@end