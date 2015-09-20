//
//  NTTableViewController.m
//  CollapsibleTableView
//
//  Created by Sathish Chinniah on 11/08/15.
//  Copyright (c) 2015 sathish chinniah. All rights reserved.
//

#import "NTTableViewController.h"

@interface NTTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation NTTableViewController

#define ROTATE 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.wantsFullScreenLayout = YES;
        
        CGRect frame = self.view.frame;
        NSLog(@"frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.view.backgroundColor  = [UIColor redColor];
        
        self.table = [[UITableView alloc] initWithFrame:frame];
        
        //all this is doing is making a call to Core Graphic’s API in order to
        //rotate our view 90 degrees counter clockwise.
#ifdef ROTATE
        self.table.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
#endif
        //and now we need to give the new frame after tranformation.
        self.table.frame = self.view.frame;
        
        //We change paging behavior so that the scrolling always shows a full page.
        self.table.pagingEnabled = YES;
        
        //And of course, we will handle the delegate/datasource.
        self.table.delegate = self;
        self.table.dataSource = self;
        
        //Finally, add our table to the view.
        [self.view addSubview:self.table];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //http://stackoverflow.com/questions/14039139/how-to-set-ios-uitableview-loop-scroll
    //TODO: the above trick to get looping table.
    return 100000;
    
    //simply show some pages.
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height = 0;
#ifdef ROTATE
    height = self.table.frame.size.width; //not height - note that we are rotated by 90 degrees.
#else 
    height = self.table.frame.size.height;
#endif
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
#ifdef ROTATE
        //Finally we just rotate the cell 90 degrees clockwise by using M_PI * 0.5.
        //If you find this a bit off then let’s remember a few things, these cells
        //will be inside the rotated table view so if we just pass them in as they
        //are, we will see them rotated 90 degrees counter clockwise.
        cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
#endif
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //http://stackoverflow.com/questions/14039139/how-to-set-ios-uitableview-loop-scroll
    //https://github.com/bharath2020/UITableViewTricks/blob/master/CircleView/BBTableView/BBTableView.m
    //Loop through pages.
    {
        int index = indexPath.row % 5;
        cell.textLabel.text = [NSString stringWithFormat:@"blah %d", index];
    }
    
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    else
        cell.contentView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

@end
