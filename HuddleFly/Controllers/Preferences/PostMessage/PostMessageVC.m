//
//  PostMessageVC.m
//  HuddleFly
//
//  Created by Jignesh on 16/09/15.
//  Copyright (c) 2015 Jignesh. All rights reserved.
//

#import "PostMessageVC.h"
#import "Base64.h"
#import "NSData+Base64.h"
#import "Global.h"
#import "ImageCell.h"
#import "SSZipArchive.h"
#import "LocalEvents.h"

@interface PostMessageVC () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL isImageSelected;
    NSMutableArray *images;
    NSMutableArray *arrNumber;
    
    int MaxImages;
}
    @property (weak, nonatomic) IBOutlet UICollectionView *imageCV;
    
    @end

@implementation PostMessageVC

#pragma mark - Life Cycle

- (NSString *)helpPath {
    return @"5-1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setNavBarTitle:self.heading];
    [super setBackBarItem];
    [super setHelpBarButton:[[User currentUser] getConsoleOption]];//ADDED BY DHAWAL 29-JUN-2017

    if ([[User currentUser] getPOSTAMESSAGE] != nil) {
        if ([[User currentUser] getPOSTAMESSAGE].length > 0) {
            self.txtMsg.text = [[User currentUser] getPOSTAMESSAGE];
        }
    }
    
    MaxImages = 10;
    
    arrNumber = [[NSMutableArray alloc] init];
    [self getTransition];
    [self getPostMessage];
    [self getImageFromHuddleFly];
    [Global roundBorderSet:_updateBtn];
    [Global roundBorderSet:_btnSelect];
    
    [[_txtMsg layer] setCornerRadius:5.0f];
    [[_txtMsg layer] setMasksToBounds:YES];
    

    [[_txtMsg layer] setBorderWidth: 1.0f];
    [[_txtMsg layer] setBorderColor:[UIColor blackColor].CGColor];
    
         
    images = [NSMutableArray new];
}

- (IBAction)onClickFullScreen:(id)sender
{
    self.btnFullScreen.selected = false;
    self.btnTextAndImage.selected = false;
    self.btnMarquee.selected = false;
    self.btnText.selected = false;
    
    UIButton* button = (UIButton*)sender;
    
    button.selected = true;
}

#pragma mark - Actions

- (IBAction)onClickSubmit:(id)sender {
    
    if (self.txtMsg.text.length == 0 || [self.txtMsg.text isEqualToString:@"Type your message"]) {
        [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Please enter message."];
        return;
    }
    [self.txtMsg resignFirstResponder];
    
    [[User currentUser] setPOSTAMESSAGE:self.txtMsg.text];
    [self updatePostMessage];
}

-(void)updatePostMessage
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:POST_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    [dictParam setObject:self.txtMsg.text forKey:kAPI_PARAM_POSTAMESSAGE];
    
    [dictParam setObject:self.pixTransitionTextField.text forKey:@"PixTransit"];
    
    if(self.btnTextAndImage.isSelected)
        [dictParam setObject:@"1" forKey:kAPI_PARAM_ISFULLSCREEN];
    else if(self.btnFullScreen.isSelected)
        [dictParam setObject:@"2" forKey:kAPI_PARAM_ISFULLSCREEN];
    else if(self.btnMarquee.isSelected)
        [dictParam setObject:@"3" forKey:kAPI_PARAM_ISFULLSCREEN];
    else if(self.btnText.isSelected)
    [dictParam setObject:@"4" forKey:kAPI_PARAM_ISFULLSCREEN];
    
    [afn getDataFromPath:kAPI_PATH_UPDATE_POST_MESSAGE withParamData:dictParam withBlock:^(id response, NSError *error) {
        
//        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            if([[dict objectForKey:@"result"] isEqualToString:@"0"] && [[dict objectForKey:@"error"] isEqualToString:@""])
            {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"Update successful. You can now \"Submit Preference\" to HuddleFly."];
            }
//            if(self.imgSelect.image && isImageSelected){
//            if(self->images.count > 0){
//                [self imageUpload];
//            }else{
                [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
//            }
        }
        else{
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(void)getPostMessage
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    //NSString *apiPath = [NSString stringWithFormat:@"%@?%@=%@&%@=%@",kAPI_PATH_GET_POST_MESSAGE,kAPI_PARAM_USERID,[[User currentUser] userID],kAPI_PARAM_DEVICEID,[[User currentUser] getDeviceId]];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];

    
    [afn getDataFromPath:@"GetPostAMessage2" withParamData:dictParam withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            NSDictionary *dict = response;
            self.txtMsg.text = [dict objectForKey:kAPI_PARAM_POSTAMESSAGE];
            self.pixTransitionTextField.text = [dict objectForKey:@"PixTransit"];
            [[User currentUser] setPOSTAMESSAGE:self.txtMsg.text];
            
            NSString* imageFullScreen = [dict objectForKey:@"ImageFullScreen"];
            
            MaxImages = [[dict objectForKey:@"MaxImages"] intValue];
            
            self.btnFullScreen.selected = false;
            self.btnTextAndImage.selected = false;
            self.btnMarquee.selected = false;

            if ([imageFullScreen isEqualToString:@"1"]) {
                
                self.btnTextAndImage.selected = true;

            } else if ([imageFullScreen isEqualToString:@"2"]) {
                
                self.btnFullScreen.selected = true;

                
            } else if ([imageFullScreen isEqualToString:@"3"]) {
                self.btnMarquee.selected = true;

            } else if ([imageFullScreen isEqualToString:@"4"]) {
                self.btnText.selected = true;
                
            }
            
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
    }];
}

-(IBAction)chooseImage:(UIButton *)sender
{
    if (images.count >= MaxImages) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Max images limit" message:[NSString stringWithFormat:@"You can upload only up to %d images.", MaxImages] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Photos",@"Camera",nil];
    
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:NULL];
            break;
            
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:controller animated:YES completion:NULL];
            }
            else
                [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:@"Device has no camera"];
            break;
            
        default:
            break;
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
//    self.imgSelect.image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [images addObject:image];
    [_imageCV reloadData];
    
    isImageSelected = YES;
    
    [self uploadImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    CGFloat width = newSize.width;
    CGFloat height = newSize.height;
    if (image.size.height > image.size.width){
        height = image.size.height * (image.size.width/image.size.height);
        width = image.size.width * (image.size.width/image.size.height);
    }
    else if (image.size.height < image.size.width){
        width = image.size.width * (image.size.height/image.size.width);
        height = image.size.height * (image.size.height/image.size.width);
    }
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext( size );
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imageUpload
{
    if(images.count == 0){
        return;
    }
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];

    [Base64 initialize];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *filePathAndDirectory = [basePath stringByAppendingPathComponent:@"tempUploading"];
    NSError *error;
    
    BOOL success = [NSFileManager.defaultManager removeItemAtPath:filePathAndDirectory error:&error];
    if (success) {
        NSLog(@"Deleted directory tempUploading");
    }
    else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    error = nil;
    success = [[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                        withIntermediateDirectories:NO
                                                         attributes:nil
                                                              error:&error];
    if (success) {
        NSLog(@"Created directory tempUploading");
    } else
    {
        NSLog(@"Create directory error: %@", error);
    }
    
    for(UIImage *image in images) {
        UIImage *img = [PostMessageVC imageWithImage:image scaledToSize:CGSizeMake(400, 400)];
        NSData *imageData = UIImageJPEGRepresentation(img, 0.6);
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@.jpg", (__bridge NSString *)uuidString];
        CFRelease(uuidString);
        
        NSString *filePath = [filePathAndDirectory stringByAppendingPathComponent:uniqueFileName];
        
        [imageData writeToFile:filePath atomically:YES];
    }
    NSString *zipPath = [basePath stringByAppendingPathComponent:@"images.zip"];
    
    error = nil;
    success = [NSFileManager.defaultManager removeItemAtPath:zipPath error:&error];
    if (success) {
        NSLog(@"Deleted directory images.zip");
    }
    else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    [SSZipArchive createZipFileAtPath:zipPath withContentsOfDirectory:filePathAndDirectory];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:zipPath];
    NSString *strBase64 = [Base64 encode:data];
    
//    UIImage *img = [PostMessageVC imageWithImage:self.imgSelect.image scaledToSize:CGSizeMake(200, 200)];
//    NSData *imageData = UIImageJPEGRepresentation(img, 0.1);
//    NSString *strBase64 = [Base64 encode:imageData];
//    NSLog(@"Image Data Size :%lu",(unsigned long)[imageData length]);
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
//    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
//    [dictParam setObject:strBase64 forKey:@"Base64String"];
    
    NSURL *url2 = [NSURL URLWithString:@"https://app.logiqfish.com/User/Mobile/PostAnImage2"];
//    NSURL *url2 = [NSURL URLWithString:@"https://app.huddlefly.net/User/Mobile/PostAnImage2"];
    
    NSDictionary *jsonDictionary = @{@"UserID" : [[User currentUser] userID],
                                     @"Base64String"    : strBase64,
                                     kAPI_PARAM_DEVICEID:[[User currentUser]getDeviceId]};
//    NSError *error;
    error = nil;
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    NSAssert(httpBody, @"dataWithJSONObject error: %@", error);
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request2 setHTTPBody:httpBody];
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (!data) {
            NSLog(@"sendAsynchronousRequest error: %@", connectionError);
            [[AppDelegate sharedAppDelegate] showToastMessage:connectionError.localizedDescription];
            return;
        }
        
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"HTML: %@", myString);
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"responseString2 = %@", dict);
        if([[dict objectForKey:@"error"] isEqualToString:@""])
        {
            //[[AppDelegate sharedAppDelegate] showToastMessage:@"Image uploaded!"];
        }
        else
        {
            //[[AppDelegate sharedAppDelegate] showToastMessage:@"Image upload failed!"];
        }
        
    }];
}
    
    - (void)uploadImage:(UIImage*)image {
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@"Uploading.."];
        UIImage *img = [PostMessageVC imageWithImage:image scaledToSize:CGSizeMake(600, 600)];
        NSData *imageData = UIImageJPEGRepresentation(img, 0.8);
        NSString *strBase64 = [Base64 encode:imageData];
        NSLog(@"Image Data Size :%lu",(unsigned long)[imageData length]);
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
        [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
        [dictParam setObject:strBase64 forKey:@"Base64String"];
        
        NSURL *url2 = [NSURL URLWithString:@"https://app.logiqfish.com/User/Mobile/PostAnImage2"];
//        NSURL *url2 = [NSURL URLWithString:@"https://app.huddlefly.net/User/Mobile/PostAnImage2"];
        
        NSDictionary *jsonDictionary = @{@"UserID" : [[User currentUser] userID],
                                         @"Base64String"    : strBase64,
                                         kAPI_PARAM_DEVICEID:[[User currentUser]getDeviceId]};
        
        NSError *error;
        NSData *httpBody = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
        NSAssert(httpBody, @"dataWithJSONObject error: %@", error);
        
        NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
        [request2 setHTTPMethod:@"POST"];
        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request2 setHTTPBody:httpBody];
        
        [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
            if (!data) {
                NSLog(@"sendAsynchronousRequest error: %@", connectionError);
                [[AppDelegate sharedAppDelegate] showToastMessage:connectionError.localizedDescription];
                return;
            }
            
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HTML: %@", myString);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseString2 = %@", dict);
            if([[dict objectForKey:@"error"] isEqualToString:@""])
            {
                //[[AppDelegate sharedAppDelegate] showToastMessage:@"Image uploaded!"];
            }
            else
            {
                //[[AppDelegate sharedAppDelegate] showToastMessage:@"Image upload failed!"];
            }
            
        }];
    }
    
    - (void)deleteImage:(NSString *)imageUrl
    {
        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@"Deleting.."];
        AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
        [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
        
        NSString * escapedQuery = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        [dictParam setObject:escapedQuery forKey:@"ImageURL"];
        
        [afn getDataFromPath:@"RemoveImage" withParamData:dictParam withBlock:^(id response, NSError *error) {
            if (response) {
//                if(![[response objectForKey:@"result"] isKindOfClass:[NSNull class]]){
//                    NSString *strUrl = [response objectForKey:@"result"];
//                    NSArray *arr = [strUrl componentsSeparatedByString:@";"];
//                    self->images = [arr mutableCopy];
//                    [self imageData:arr[0]];
//                    [self->_imageCV reloadData];
//                }
            }
            else{
                [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
            }
            [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        }];
    }

- (void)getImageFromHuddleFly
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:[[User currentUser] userID] forKey:kAPI_PARAM_USERID];
    [dictParam setObject:[[User currentUser] getDeviceId] forKey:kAPI_PARAM_DEVICEID];
    
    [afn getDataFromPath:kApi_PATH_GET_POSTIMAGE withParamData:dictParam withBlock:^(id response, NSError *error) {
        if (response) {
            if(![[response objectForKey:@"result"] isKindOfClass:[NSNull class]]){
                NSString *strUrl = [response objectForKey:@"result"];
                if (![strUrl isEqualToString:@""]) {
                    NSArray *arr = [strUrl componentsSeparatedByString:@";"];
                    self->images = [arr mutableCopy];
//                    [self imageData:arr[0]];
                    [self->_imageCV reloadData];
                }
            }
        }
        else{
            [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        }
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
    }];
}

- (void)imageData :(NSString *)strUrl{
    
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:strUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if(data){
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImage *img = [UIImage imageWithData:data];
                                       if(img){
                                           self.imgSelect.image = img;
                                           isImageSelected = YES;
                                       }else{
                                           isImageSelected = NO;
                                       }
                                       [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
                                   });
                                   
                               }
                               else
                                  [[AppDelegate sharedAppDelegate] showToastMessage:connectionError.localizedDescription];
                               
                           }];
    
}

#pragma mark - UITextField Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.txtMsg.text isEqualToString:@"Type your message"]) {
        self.txtMsg.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 500) return NO;
    
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return images.count;
    }
    
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        id image = images[indexPath.item];
        
        if ([image isKindOfClass:UIImage.class]) {
            cell.imageView.image = image;
        } else if ([image isKindOfClass:NSString.class]) {
            [cell imageData:image];
        }
        
        [cell setRemoveImage:^{
            if ([image isKindOfClass:NSString.class]) {
                [self deleteImage:image];
            }
            [images removeObjectAtIndex:indexPath.item];
            [_imageCV reloadData];
        }];
        
        [cell setImageLoaded:^(UIImage *image) {
//            [images replaceObjectAtIndex:indexPath.item withObject:image];
        }];
        return cell;
    }

- (void) getTransition
{
    [[AppDelegate sharedAppDelegate] showHUDLoadingView:@""];
    AFNHelper *afn = [[AFNHelper alloc] initWithRequestMethod:GET_METHOD];
    
    [afn getDataFromPath:@"GetTransitionList" withParamData:nil withBlock:^(id response, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        if (response) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                [arrNumber removeAllObjects];
                for (NSDictionary *dict in response) {
                    Transition *d = [[Transition alloc] init];
                    [d setData:dict];
                    [arrNumber addObject:d];
                }
                
            }
        }
    }];
}



    - (IBAction)onClickTextField:(UITextField *)sender
    {
        [sender becomeFirstResponder];
        [sender resignFirstResponder];
        NSString* pickerTitle;
        pickerTitle = @"Transition Duration(in Seconds)";
        NSMutableArray *transitions = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < arrNumber.count; i++) {
            Transition * obj = [arrNumber objectAtIndex:i];
            [transitions addObject: obj.value];
        }
        [ActionSheetStringPicker showPickerWithTitle:pickerTitle rows:transitions initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            
            sender.text = transitions[selectedIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:sender];
        
    }
    
@end
