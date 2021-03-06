//
//  QRDonViSanPhamTableViewCell.h
//  ViViMASS
//
//  Created by Tam Nguyen on 3/2/18.
//

#import <UIKit/UIKit.h>

@interface QRDonViSanPhamTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lblTenHienThi;
@property (retain, nonatomic) IBOutlet UIImageView *imgvQR;
@property (retain, nonatomic) IBOutlet UIButton *btnPhongToQR;
@property (retain, nonatomic) IBOutlet UIButton *btnPhongToAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lblGia;
@property (retain, nonatomic) IBOutlet UILabel *lblDC1;
@property (retain, nonatomic) IBOutlet UILabel *lblDC2;

@end
