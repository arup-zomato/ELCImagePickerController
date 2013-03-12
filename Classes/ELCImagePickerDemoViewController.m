//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@implementation ELCImagePickerDemoViewController

@synthesize scrollview;

-(IBAction)launchController {
	
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    ELCImagePickerDemoAppDelegate *app = (ELCImagePickerDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.viewController presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [albumController release];
}

#pragma mark ELCImagePickerControllerDelegate Methods

NSMutableArray *dataObjects;

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissViewControllerAnimated:YES completion:^{
	
        dataObjects = [NSMutableArray arrayWithArray:info];
        for (UIView *v in [scrollview subviews]) {
            [v removeFromSuperview];
        }
    
        CGRect workingFrame = scrollview.frame;
        workingFrame.origin.x = 0;
        
        
        ALAsset *dummy1 = (ALAsset *) [info lastObject];
        ALAsset *dummy2 = (ALAsset *)[info objectAtIndex:0];
        
        [dataObjects insertObject:dummy1 atIndex:0];
        [dataObjects addObject:dummy2];
	
        for(ALAsset *asset in dataObjects) {
	
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            imageview.frame = workingFrame;
		
            [scrollview addSubview:imageview];
            [imageview release];
		
            workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        }
	
        [scrollview setPagingEnabled:YES];
        
        [scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
        
        [scrollview scrollRectToVisible:CGRectOffset(scrollview.frame, workingFrame.size.width, 0) animated:NO];
        
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {

	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollview.contentOffset.x == 0) {
        NSLog(@"%@", @"we are at zero");
        [scrollview scrollRectToVisible:CGRectOffset(scrollview.frame, (scrollview.contentSize.width - 2 * scrollview.frame.size.width), 0) animated:NO];
    } else if(scrollview.contentOffset.x == (scrollview.contentSize.width - scrollview.frame.size.width)) {
        NSLog(@"%@", @"we are at last");
        [scrollview scrollRectToVisible:CGRectOffset(scrollview.frame, (scrollview.frame.size.width), 0) animated:NO];

    }
}

- (void)dealloc {
    [super dealloc];
}

@end
