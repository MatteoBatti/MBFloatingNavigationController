//
//  ViewController.m
//  CustomNavigationBehav
//
//  Created by Matteo Battistini on 04/11/15.
//  Copyright © 2015 MB. All rights reserved.
//

#import "ViewController.h"
#import "CustomNavigationBar.h"
#import "CustomNavigationController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TableViewController *tvc = [sb instantiateViewControllerWithIdentifier:@"TableViewController"];
    CustomNavigationController *vc = [[CustomNavigationController alloc] initWithNavigationBarClass:[CustomNavigationBar class]
                                                                                        navBarHight:100
                                                                                       toolbarClass:nil];
    vc.viewControllers = @[tvc];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
