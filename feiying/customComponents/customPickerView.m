//
//  customPickerView.m
//  feiying
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "customPickerView.h"

@implementation customPickerView

@synthesize customPickerDelegate = _mCustomPickerDelegate;

@synthesize pickerTitleLabel = _mPickerTitleLabel;

// private methods
-(void) pickerDoneSelectedAction{
    //NSLog(@"customPickerView - pickerDoneSelectedAction.");
    
    if(_mCustomPickerDelegate){
        [_mCustomPickerDelegate pickerDoneSelected];
    }
}

// self init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // header toolbar
        UIToolbar *_headerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.frame.size.width, 36.0)];
        _headerToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *_pickerDoneButtonBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneSelectedAction)];
        // set picker done button barButtonItem width
        _pickerDoneButtonBarButtonItem.width = 50.0f;
        
        // picker title label
        _mPickerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerToolbar.bounds.origin.x+5.0, _headerToolbar.bounds.origin.y+4.0, _headerToolbar.frame.size.width-2*5.0-_pickerDoneButtonBarButtonItem.width-15.0, 28.0)];
        _mPickerTitleLabel.backgroundColor = [UIColor clearColor];
        // set text
        _mPickerTitleLabel.textAlignment = UITextAlignmentCenter;
        _mPickerTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        // create picker title label buttonBarItem
        UIBarButtonItem *_pickerTitleButtonBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_mPickerTitleLabel];
        
        // set toolBar items
        _headerToolbar.items = [NSArray arrayWithObjects:_pickerTitleButtonBarButtonItem, _pickerDoneButtonBarButtonItem, nil];
        
        // init uipicker view
        _mPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        // could reset size
        _mPickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // set frame
        _mPickerView.frame = CGRectMake(self.bounds.origin.x, _headerToolbar.frame.origin.y+_headerToolbar.frame.size.height, self.frame.size.width, 140.0);
        _mPickerView.showsSelectionIndicator = YES;
        
        // add to view
        [self addSubview:_headerToolbar];
        [self addSubview:_mPickerView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// methods implemetation
-(void) setPickerDataSource:(id<UIPickerViewDataSource>) pPickerDataSource{
    _mPickerView.dataSource = pPickerDataSource;
}

-(void) setPickerDelegate:(id<UIPickerViewDelegate>) pPickerDelegate{
    _mPickerView.delegate = pPickerDelegate;
}

-(NSInteger) getPickerViewSelectedRowInComponent:(NSInteger)pComponent{
    return [_mPickerView selectedRowInComponent:pComponent];
}

-(void) setPickerViewSelectedRow:(NSInteger)pRow InComponent:(NSInteger)pComponent{
    [_mPickerView selectRow:pRow inComponent:pComponent animated:NO];
}

@end
