//
//  AssetTablePicker.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ELCAsset.h"

@interface ELCAssetTablePicker : UITableViewController <ELCAssetDelegate>
{
	ALAssetsGroup *assetGroup;
	
    NSMutableArray *selectedAssets;
    
    NSMutableDictionary *assetRows;
	
	id parent;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) BOOL startsAtBottom;

-(int)totalSelectedAssets;


-(void)doneAction:(id)sender;

@end