//
//  customPickerView.h
//  feiying
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol customPickerViewDelegate <NSObject>

-(void) pickerDoneSelected;

@end

@interface customPickerView : UIView{
    // ui picker view
    UIPickerView * _mPickerView;
    
    // picker title Label
    UILabel *_mPickerTitleLabel;
    
    // customPickerViewDelegate
    id<customPickerViewDelegate> _mCustomPickerDelegate;
}

@property (nonatomic, retain) id<customPickerViewDelegate> customPickerDelegate;

@property (nonatomic, retain) UILabel *pickerTitleLabel;

// set customPickerView picker view data source
-(void) setPickerDataSource:(id<UIPickerViewDataSource>) pPickerDataSource;
// set customPickerView picker view delegate
-(void) setPickerDelegate:(id<UIPickerViewDelegate>) pPickerDelegate;

// get picker view selected row in component
-(NSInteger) getPickerViewSelectedRowInComponent:(NSInteger) pComponent;

// set picker view selected row in component
-(void) setPickerViewSelectedRow:(NSInteger) pRow InComponent:(NSInteger) pComponent;

@end
