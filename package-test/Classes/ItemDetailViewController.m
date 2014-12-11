//
//  ItemDetailViewController.m
//  package-test
//
//  Created by bkendall on 12/8/14.
//  Copyright (c) 2014 kendall. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "SFRestAPI.h"

@interface ItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *itemPriceTextfield;
@property (strong, nonatomic) IBOutlet UITextField *itemQtyTextField;

@end

@implementation ItemDetailViewController

@synthesize itemQty;
@synthesize itemPrice;
@synthesize itemID;
@synthesize itemName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.itemNameLabel.text = itemName;
    self.itemPriceTextfield.text = [itemPrice stringValue];
    self.itemQtyTextField.text = [itemQty stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateData:(id)sender {
    [self updateWithObjectType:@"kendallsoftware__Merchandise__c"
                      objectId:self.itemID
                      quantity:self.itemQtyTextField.text
                         price:self.itemPriceTextfield.text];
}

- (void)updateWithObjectType:(NSString *)objectType
                    objectId:(NSString *)objectId
                    quantity:(NSString *)quantity
                       price:(NSString *)price {
    
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:quantity, @"kendallsoftware__Quantity__c", price, @"kendallsoftware__Price__c", nil];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:objectType objectId:objectId fields:fields];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}
- (id) initWithName:(NSString *)recordName
          sobjectId:(NSString *)salesforceId
           quantity:(NSNumber *)recordQuantity
              price:(NSNumber *)recordPrice {
    self = [super init];
    
    if (self) {
        itemQty = recordQuantity;
        itemPrice = recordPrice;
        itemID = salesforceId;
        itemName = recordName;
    }
    
    return self;
}

- (void)hideKeyboard {
    [self.itemQtyTextField resignFirstResponder];
    [self.itemPriceTextfield resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

#pragma mark SFRestDelegate
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSLog(@"1 record updated");
//    [self.navigationController popViewControllerAnimated:YES];
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
}
@end
