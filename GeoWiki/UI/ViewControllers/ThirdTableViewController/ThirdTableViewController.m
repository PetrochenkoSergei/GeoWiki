//
//  ThirdTableViewController.m
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import "ThirdTableViewController.h"

@interface ThirdTableViewController (){
    NSString *pathToPlist;
    NSUserDefaults *defaults;
}

@end

@implementation ThirdTableViewController
@synthesize radiusField,limitField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger radius = [defaults integerForKey:@"radius"];
    NSInteger limit = [defaults integerForKey:@"limit"];
    
    radiusField.text = [NSString stringWithFormat:@"%ld", radius];
    limitField.text = [NSString stringWithFormat:@"%ld", limit];
    
}

- (IBAction)saveButtonClick:(id)sender{
    if (radiusField.text.intValue < 10 || radiusField.text.intValue > 10000) {
        [self presentAlertControllerWithTitle:@"Ошибка" message:@"Неверное значение области поиска"];
    }else if (limitField.text.intValue < 1 || limitField.text.intValue > 50){
        [self presentAlertControllerWithTitle:@"Ошибка" message:@"Неверное значение количества новостей"];
    }else{
        [self.view endEditing:YES];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:radiusField.text.intValue forKey:@"radius"];
        [defaults setInteger:limitField.text.intValue forKey:@"limit"];
        [defaults synchronize];
        
        [self presentAlertControllerWithTitle:@"Сохранено" message:@"Настройки успешно сохранены"];
    }
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
