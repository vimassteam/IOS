//
//  QRVC.h
//  ViViMASS
//
//  Created by Mac Mini on 10/11/18.
//

#import <UIKit/UIKit.h>
#import "RowSelectDelegate.h"

@interface QRVC : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *arrDanhSach;
@property(assign) id<RowSelectDelegate> delegate;

@end
