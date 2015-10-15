//
//  ViewController.h
//  EBPublishDemo
//
//  Created by EggmanQi on 15/10/15.
//  Copyright © 2015年 EggmanQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, weak)IBOutlet UIView *containView;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *containButtomConstraint;

@property(nonatomic, weak)IBOutlet UITextView *inputTextView;
@property(nonatomic, weak)IBOutlet UILabel *wordCountLabel;

@end

