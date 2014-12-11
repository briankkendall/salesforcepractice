//
//  FileShareTableViewController.m
//  package-test
//
//  Created by bkendall on 12/9/14.
//  Copyright (c) 2014 kendall. All rights reserved.
//

#import "FileShareTableViewController.h"


@interface FileShareTableViewController ()

@end

@implementation FileShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"FileShare";
    self.thumbnailCache = [NSMutableDictionary dictionary];
    self.imageView = [[UIImageView alloc] init];
    _ownedFilesButton = [[UIBarButtonItem alloc] initWithTitle:@"Owned" style:UIBarButtonItemStylePlain target:self action:@selector(showOwnedFiles)];
    _groupsFilesButton = [[UIBarButtonItem alloc] initWithTitle:@"Groups" style:UIBarButtonItemStylePlain target:self action:@selector(showGroupsFiles)];
    _sharedFilesButton = [[UIBarButtonItem alloc] initWithTitle:@"Shared" style:UIBarButtonItemStylePlain target:self action:@selector(showSharedFiles)];    
    _addFileShareButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFiles)];
    
    self.navigationItem.rightBarButtonItems = @[_ownedFilesButton, _groupsFilesButton, _addFileShareButton, _sharedFilesButton];
}

- (void) getThumbnail:(NSString*) fileId completeBlock:(ThumbnailLoadedBlock)completeBlock {
    // cache hit
    if (self.thumbnailCache[fileId]) {
        completeBlock(self.thumbnailCache[fileId]);
    }
    // cache miss
    else {
        [self downloadThumbnail:fileId completeBlock:^(UIImage *image) {
            // size it
            UIGraphicsBeginImageContext(CGSizeMake(120,90));
            [image drawInRect:CGRectMake(0, 0, image.size.width, 90)];
            UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // cache it
            self.thumbnailCache[fileId] = thumbnailImage;
            // done
            completeBlock(thumbnailImage);
        }];
    }
}

- (void) downloadThumbnail:(NSString*)fileId completeBlock:(ThumbnailLoadedBlock)completeBlock {
    SFRestRequest *imageRequest = [[SFRestAPI sharedInstance] requestForFileRendition:fileId version:nil renditionType:@"THUMB120BY90" page:0];
    [[SFRestAPI sharedInstance] sendRESTRequest:imageRequest failBlock:nil completeBlock:^(NSData *responseData) {
        NSLog(@"downloadThumbnail:%@ completed", fileId);
        UIImage *image = [UIImage imageWithData:responseData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(image);
        });
    }];
}

- (void) showOwnedFiles
{
    NSLog(@"Show Owned Files Pressed");
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForOwnedFilesList:nil page:0];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void) showGroupsFiles
{
    NSLog(@"Show Group Files Pressed");
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForFilesInUsersGroups:nil page:0];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void) showSharedFiles
{
    NSLog(@"Show Shared Files Pressed");
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForFilesSharedWithUser:nil page:0];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void) shareFiles
{
    NSLog(@"Share Files Pressed");
    
    NSString *id = @"some_file_id";
    NSString *entId = @"some_entity_id";
    SFRestRequest *requestAdd = [[SFRestAPI sharedInstance] requestForAddFileShare:id
                                              entityId:entId
                                             shareType:@"V"];
    
    SFRestRequest *requestShared = [[SFRestAPI sharedInstance] requestForFilesSharedWithUser:nil page:0];
}

- (void)uploadFiles {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image =  chosenImage;
    self.imgPicker = picker;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Name?"
                                                    message:@"  "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

//    NSData *imageData= UIImageJPEGRepresentation(chosenImage,0.0);
//    SFRestRequest *request =
//    [[SFRestAPI sharedInstance] requestForUploadFile:imageData
//                                                name:@"TestPDog.png"
//                                         description:@"Share Img"
//                                            mimeType:@"image/png"];
//    [[SFRestAPI sharedInstance] send:request delegate:self];
//    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {

}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

#pragma - mark UIAlertviewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSData *imageData= UIImageJPEGRepresentation(self.imageView.image,0.0);
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        SFRestRequest *request =
        [[SFRestAPI sharedInstance] requestForUploadFile:imageData
                                                    name:[NSString stringWithFormat:@"%@.png",alertText]
                                             description:@"Share Img"
                                                mimeType:@"image/png"];
        [[SFRestAPI sharedInstance] send:request delegate:self];
        [self.imgPicker dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
