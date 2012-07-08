//
//  AssetTablePicker.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAlbumPickerController.h"


@implementation ELCAssetTablePicker

@synthesize parent;
@synthesize selectedAssetsLabel;
@synthesize assetGroup;
@synthesize startsAtBottom;

-(void)viewDidLoad {
    
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    
    selectedAssets = [[NSMutableArray alloc] initWithCapacity:10];
    assetRows = [[NSMutableDictionary alloc] initWithCapacity:100];
	
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self.navigationItem setTitle:@"Pick Photos"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.startsAtBottom) {
        [self scrollToBottom];
    }
}

- (void) doneAction:(id)sender {
    
    [(ELCAlbumPickerController*)self.parent selectedAssets:selectedAssets];
}

- (void)scrollToBottom
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(assetGroup.numberOfAssets / 4.0)-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.assetGroup numberOfAssets] / 4.0);
}

- (NSIndexSet *)assetGroupIndexesForIndexPath:(NSIndexPath *)indexPath
{
    int index = (indexPath.row * 4);
	int maxIndex = (indexPath.row * 4 + 3);
    
    int count = self.assetGroup.numberOfAssets;
    
    if (maxIndex < count) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 4)];
    } else if(maxIndex - 1 < count) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 3)];
    } else if(maxIndex - 2 < count) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 2)];
    } else if(maxIndex - 3 < count) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 1)];
    }
    
    return nil;
}

- (NSArray*)assetsForIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cachedRow = [assetRows objectForKey:indexPath];
    if (cachedRow) {
        return cachedRow;
    }
    
    NSIndexSet *indexes = [self assetGroupIndexesForIndexPath:indexPath];
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:4];
    
    [self.assetGroup enumerateAssetsAtIndexes:indexes options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        ELCAsset *asset = [[[ELCAsset alloc] initWithAsset:result] autorelease];
        [asset setParent:self];
        
        [assets addObject:asset];
    }];
    
    [assetRows setObject:assets forKey:indexPath];
    
    return assets;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {		        
        cell = [[[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

- (int)totalSelectedAssets {
    
    return [selectedAssets count];
}

- (void)dealloc 
{
    [selectedAssetsLabel release];
    [selectedAssets release];
    [assetRows release];
    [super dealloc];    
}

#pragma mark - ELCAssetDelegate methods

- (void)elcAsset:(ELCAsset *)elcAsset wasSelected:(BOOL)selected
{
    if (selected) {
        [selectedAssets addObject:[elcAsset asset]];
    } else {
        [selectedAssets removeObject:[elcAsset asset]];
    }
}

@end
