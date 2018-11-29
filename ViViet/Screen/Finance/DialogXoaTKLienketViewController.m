//
//  DialogXoaTKLienketViewController.m
//  ViViMASS
//
//  Created by Nguyen Van Hoanh on 11/27/18.
//

#import "DialogXoaTKLienketViewController.h"
#import "ExTextField.h"
@interface DialogXoaTKLienketViewController ()
@property (retain, nonatomic) IBOutlet UIButton *btnToken;
@property (retain, nonatomic) IBOutlet UIButton *btnVantay;
@property (retain, nonatomic) IBOutlet ExTextField *txtToken;
@property (retain, nonatomic) IBOutlet UIButton *btnThuchien;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintLeading;

@end

@implementation DialogXoaTKLienketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setitleLable:(NSString*)title {
    _lblTitle.text = title;
}
- (void)xuLyKhiKhongCoChucNangQuetVanTay
{
    _btnToken.hidden = false;
    _txtToken.hidden = YES;
    _btnThuchien.hidden = YES;
    _btnVantay.hidden = YES;
    _contraintLeading.constant = ([UIScreen mainScreen].bounds.size.width - 44)/2 - 22 ;
}

- (void)xuLyKhiCoChucNangQuetVanTay
{
    _btnToken.hidden = true;
    _txtToken.hidden = true;
    _btnVantay.hidden = false;
    _contraintLeading.constant = 95;
}

- (void)xuLySuKienDangNhapVanTay
{
    [self xuLySuKienHienThiChucNangVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_token_VIMASS" localizableString]];
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    self.mTypeAuthenticate = TYPE_kieuXacThuc_khac;
    if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
    {
        NSString *sToken = @"";
        NSString *sOtp = @"";
        NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
        NSString *token = [DucNT_Token layMatKhauVanTayToken];
        if(sSeed.length > 0)
        {
            sToken = [DucNT_Token OTPFromPIN:token seed:sSeed];
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
        }
        [self.mDelegate xuLySuKienXacThucVoiKieu:self.mTypeAuthenticate token:sToken otp:sOtp];
    }

}

- (void)hienThiThongBaoDienMatKhau
{
    [UIAlertView alert:[@"thong_bao_xac_thuc_van_tay_khong_dung" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
}

- (IBAction)dotoken:(id)sender {
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
    [self.btnVantay setSelected:NO];
    self.btnToken.hidden = false;
    self.txtToken.hidden = NO;
    self.btnThuchien.hidden = NO;

}
- (IBAction)doVantay:(id)sender {
    self.mTypeAuthenticate = TYPE_kieuXacThuc_khac;
    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    [self.btnVantay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    [self.btnVantay setSelected:YES];
    [self.btnToken setSelected:NO];
    self.txtToken.hidden = YES;
    self.btnThuchien.hidden = YES;
    
    NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    if(sKeyDangNhap.length > 0)
    {
        [self xuLySuKienHienThiChucNangDangNhapVanTayVoiTieuDe:[@"su_dung_van_tay_dang_nhap_tai_khoan_VIMASS" localizableString]];
    }
    else
    {
        [UIAlertView alert:[@"thong_bao_chua_co_xac_thuc_van_tay" localizableString] withTitle:[@"thong_bao" localizableString] block:nil];
    }

}
- (IBAction)thuchien:(id)sender {
    self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN;
    if([self.txtToken validate])
    {
        if([self.mDelegate respondsToSelector:@selector(xuLySuKienXacThucVoiKieu:token:otp:)])
        {
            NSString *sToken = @"";
            NSString *sOtp = @"";
            NSString *sSeed = [DucNT_Token laySeedTokenHienTai];
            if(sSeed.length > 0)
            {
                sToken = [DucNT_Token OTPFromPIN:self.txtToken.text seed:sSeed];
            }
            else
            {
                [[[[UIAlertView alloc] initWithTitle:[@"@thong_bao" localizableString]  message:[@"@can_tao_token" localizableString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                return;
            }
            [self.mDelegate xuLySuKienXacThucVoiKieu:self.mTypeAuthenticate token:sToken otp:sOtp];
        }
    }
    else
    {
        [self.txtToken show_error];
    }

}
- (IBAction)actionClose:(id)sender {
    [self.view removeFromSuperview];
}

- (void)dealloc {
    [_btnToken release];
    [_btnVantay release];
    [_txtToken release];
    [_btnThuchien release];
    [_lblTitle release];
    [super dealloc];
}
@end