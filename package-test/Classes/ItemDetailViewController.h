//
//  ItemDetailViewController.h
//  package-test
//
//  Created by bkendall on 12/8/14.
//  Copyright (c) 2014 kendall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
@interface ItemDetailViewController : UIViewController <SFRestDelegate>
@property (nonatomic, strong) NSNumber *itemQty;
@property (nonatomic, strong) NSNumber *itemPrice;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemID;

- (id) initWithName:(NSString *)recordName
          sobjectId:(NSString *)salesforceId
           quantity:(NSNumber *)recordQuantity
              price:(NSNumber *)recordPrice;

- (void)updateWithObjectType:(NSString *)objectType
                    objectId:(NSString *)objectId
                    quantity:(NSString *)quantity
                       price:(NSString *)price;
@end
