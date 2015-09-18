//
// MWViewController.m
// MyWeather
//
// Created by Fabian Celdeiro on 1/20/15.
// Copyright (c) 2015 Fabian Celdeiro. All rights reserved.
//

#import "MWViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface MWViewController ()
@property (nonatomic,strong) MBProgressHUD * loadingMessage;
@end

@implementation MWViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)showLoadingMessage:(NSString *)_text
{
    if (!self.loadingMessage) {
        self.loadingMessage = [[MBProgressHUD alloc] initWithView:self.view];
        self.loadingMessage.isAccessibilityElement = YES;
        self.loadingMessage.removeFromSuperViewOnHide = YES;
        self.loadingMessage.mode = MBProgressHUDModeCustomView;
        [self.loadingMessage show:YES];
    } else {
        [self.loadingMessage show:NO];
    }
    
    [self.view addSubview:self.loadingMessage];
    self.loadingMessage.labelText = _text;
}

- (void)hideLoadingMessage
{
    self.loadingMessage.delegate = nil;
    [self.loadingMessage hide:YES];
}
/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

@end
