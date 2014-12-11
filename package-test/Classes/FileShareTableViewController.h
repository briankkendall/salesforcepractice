//
//  FileShareTableViewController.h
//  package-test
//
//  Created by bkendall on 12/9/14.
//  Copyright (c) 2014 kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import "SFRestAPI+Blocks.h"
#import "SFRestAPI+Files.h"
#import "SFRestRequest.h"

typedef void (^ThumbnailLoadedBlock) (UIImage *thumbnailImage);
@interface FileShareTableViewController : UITableViewController <SFRestDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    
}
@property (nonatomic, strong) UIBarButtonItem *ownedFilesButton;
@property (nonatomic, strong) UIBarButtonItem *sharedFilesButton;
@property (nonatomic, strong) UIBarButtonItem *groupsFilesButton;
@property (nonatomic, strong) UIBarButtonItem *uploadFilesButton;
@property (nonatomic, strong) UIBarButtonItem *addFileShareButton;
@property (nonatomic, strong) NSMutableDictionary *thumbnailCache;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imgPicker;

- (void) downloadThumbnail:(NSString*)fileId completeBlock:(ThumbnailLoadedBlock)completeBlock;
- (void) showOwnedFiles;
- (void) showGroupsFiles;
- (void) showSharedFiles;
- (void) uploadFiles;
//- (void) addSharing;

@end
