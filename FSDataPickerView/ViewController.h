//
//  ViewController.h
//  FSDataPickerView
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickerView.h"
#import "Logic.h"

@interface ViewController : UIViewController<UITextFieldDelegate,DataPickerViewDelegate>
@property (nonatomic,retain) UITextField *oneComponentTextField;
@property (nonatomic,retain) DataPickerView *oneComponentDataPicker;

@property (nonatomic,retain) UITextField *twoComponentTextField;
@property (nonatomic,retain) DataPickerView *twoComponentDataPicker;

@property (nonatomic,retain) UITextField *threeComponentTextField;
@property (nonatomic,retain) DataPickerView *threeComponentDataPicker;

-(void)selectDataOfRowArray:(NSMutableArray *)rowArray actionDone:(BOOL)actionDone;
-(NSString *)textOfRow:(NSInteger)row inComponent:(NSInteger)component rowArray:(NSMutableArray *)rowArray;
-(NSMutableArray*)arrayOfRowArray:(NSMutableArray *)rowArray inComponent:(NSInteger)component;
@end
