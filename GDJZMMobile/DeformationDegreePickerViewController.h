//
//  DeformationDegreePickerViewController.h
//  GDJZMMobile
//
//  Created by tiank on 16/8/16.
//
//

#ifndef GDJZMMobile_DeformationDegreePickerViewController_h
#define GDJZMMobile_DeformationDegreePickerViewController_h


#endif

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "CaseInfo.h"
#import "CaseIDHandler.h"
#import "Systype.h"

@protocol DeformationDegreePicker;

@interface DeformationDegreePickerViewController : UITableViewController

//@property (nonatomic,weak) id<DeformationDegreePickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@end

@protocol DeformationDegreePickerDelegate <NSObject>

-(void)setDegree:(NSString *)name ;

@end