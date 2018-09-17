//
//  ThirdTableViewController.h
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *radiusField;
@property (strong, nonatomic) IBOutlet UITextField *limitField;

- (IBAction)saveButtonClick:(id)sender;

@end
