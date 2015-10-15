//
//  ViewController.m
//  EBPublishDemo
//
//  Created by EggmanQi on 15/10/15.
//  Copyright © 2015年 EggmanQi. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"

@interface ViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, assign) BOOL isUseCamera;
@property(nonatomic, assign) NSInteger editLocation;
@property(nonatomic, assign) NSRange lastRange;

@property(nonatomic, strong) NSMutableArray *originalPhotoArr;
@property(nonatomic, strong) NSMutableArray *tempPhotoArr;
@property(nonatomic, strong) NSMutableArray *containArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _isUseCamera = NO;
    _editLocation = 0;
    _lastRange = NSMakeRange(0, 0);
    
    _originalPhotoArr = [NSMutableArray array];
    _containArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (void)_keyboardWillShow:(NSNotification *)aNotification
{
    //    http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation <- 参考
    
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.view convertRect:endFrameValue.CGRectValue fromView:nil];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.containButtomConstraint.constant = keyboardEndFrame.size.height + 20;
                     }
                     completion:nil];
}

- (void)_keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn//(animationCurve << 16)
                     animations:^{
                         self.containButtomConstraint.constant = 20;
                     }
                     completion:nil];
}

#pragma mark -
- (void)insertPhoto:(UIImage *)photo
{
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = photo;
    [ms insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:_editLocation];
    self.inputTextView.attributedText = ms;
}

- (void)upload
{
    NSLog(@"要上传的内容 ：%@", self.containArr);
    [self.inputTextView resignFirstResponder];
    
    NSLog(@"上传中 ……");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"传完了 ……");
    });
}

#pragma mark - Button Action
- (IBAction)onShowGallery:(id)sender
{
    [self.inputTextView resignFirstResponder];
    
    _isUseCamera = NO;
    
    UIImagePickerController *_imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    
    [self presentViewController:_imagePicker
                       animated:YES
                     completion:nil];
}

- (IBAction)onShowCamear:(id)sender
{
    [self.inputTextView resignFirstResponder];
    
    _isUseCamera = YES;
    
    UIImagePickerController *_imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.showsCameraControls = YES;
    
    [self presentViewController:_imagePicker
                       animated:YES
                     completion:nil];
}

- (IBAction)onUpload:(id)sender
{
    [self.containArr removeAllObjects];
    
    self.tempPhotoArr = [NSMutableArray arrayWithArray:self.originalPhotoArr];
    
    NSTextStorage *ts = [[NSTextStorage alloc] initWithAttributedString:[self.inputTextView.attributedText copy]];
    
    [ts enumerateAttribute:NSAttachmentAttributeName
                   inRange:NSMakeRange(0, ts.length)
                   options:0
                usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         NSLog(@"%@, %@", value, NSStringFromRange(range));
         if (value) {
 //             NSTextAttachment* attachment = (NSTextAttachment*)value;
             [self.containArr addObject:[self.tempPhotoArr[0] copy]];
 //             [self.containArr addObject:attachment.image];
             [self.tempPhotoArr removeObjectAtIndex:0];
         }else {
             
             // . @"\U0000fffc" 是 NSTextAttachment 的占位符
             
             NSString *text = [self.inputTextView.text substringWithRange:range];
             [text stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
             NSLog(@"%@", text);
             [self.containArr addObject:text];
         }
         
         if (range.length + range.location == self.inputTextView.text.length) {
             NSLog(@"end");
             [self upload];
         }
     }];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = nil;
    UIImage *finalImage = nil;
    
    if (_isUseCamera) {
//        image = info[UIImagePickerControllerEditedImage];
        image = info[UIImagePickerControllerOriginalImage];
    }else {
//        image = [info objectForKey:UIImagePickerControllerEditedImage];
        image = info[UIImagePickerControllerOriginalImage];
        image = [image fixOrientation];
    }
    
    [self.originalPhotoArr addObject:image];
    
    finalImage = [image thumbnailWithSize:CGSizeMake(60, 60)];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        _editLocation = self.inputTextView.selectedRange.location;
        if (finalImage && _editLocation>-1) {
            [self insertPhoto:finalImage];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld", textView.attributedText.length];
}

@end
