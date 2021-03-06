//
//  FooterTable.m
//  ViViMASS
//
//  Created by Mac Mini on 11/2/18.
//

#import "FooterTable.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "DucNT_LuuRMS.h"
@interface FooterTable()
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contraintLeading;

@end
@implementation FooterTable

- (BOOL)kiemTraCoChucNangQuetVanTay
{
    LAContext *laContext = [[[LAContext alloc] init] autorelease];
    NSError *error = nil;
    if([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        if (error != NULL) {
            // handle error
        } else {
            
            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    [self.btnVanTay setImage:[UIImage imageNamed:@"face-id"] forState:UIControlStateNormal];
                    [self.btnVanTay setImage:[UIImage imageNamed:@"face_new_choose"] forState:UIControlStateSelected];
                    self.hasFaceID = YES;
                    return YES;
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    [self.btnVanTay setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
                    [self.btnVanTay setImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
                    self.hasFaceID = NO;

                    return YES;
                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    return NO;
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    self.hasFaceID = NO;
    return NO;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCount:) name:@"CountMoney" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadFooter:) name:@"ReloadFooter" object:nil];
    _lblTitleTongTien.text = [@"tong_tien" localizableString];
    _lblTitlePhi.text = [@"title_phi" localizableString];
    [_btnThucHien setTitle:[@"button_thuc_hien" localizableString] forState:UIControlStateNormal];
}
-(void)reloadCount:(NSNotification*)notification{
    NSDictionary *dict = (NSDictionary*)[notification object];
    self.lbTongPhi.text = [NSString stringWithFormat:@"%@ đ", [dict objectForKey:@"Fee"]];
    self.lbTongTien.text = [NSString stringWithFormat:@"%@ đ", [dict objectForKey:@"Total"]];
}
-(void)ReloadFooter:(NSNotification*)notification{
    int type = (int)[notification object];
    if(type == 1){
        self.txtOtp.hidden = false;
//        self.btnToken.hidden = false;
        self.lbTime.hidden = false;
        self.lbCountTime.hidden = false;
        self.btnThucHien.hidden = false;
        self.txtOtp.placeholder = @"Mã xác thực";
    }
    else{
        self.txtOtp.hidden = false;
//        self.btnToken.hidden = false;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = false;
        self.txtOtp.placeholder = @"Mật khẩu token";
    }
}

- (void)dealloc {
    [_txtNoiDung release];
    [_lbTongTien release];
    [_lbTongPhi release];
    [_btnToken release];
    [_btnVanTay release];
    [_txtOtp release];
    [_lbTime release];
    [_lbCountTime release];
    [_btnThucHien release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_contraintLeading release];
    [_lblTitleTongTien release];
    [_lblTitlePhi release];
    [super dealloc];
}
-(void)setupView{
    
    if ([self kiemTraCoChucNangQuetVanTay]){
//        self.btnToken.hidden = true;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = true;
        self.txtOtp.hidden = true;
        _contraintLeading.constant = [UIScreen mainScreen].bounds.size.width/2 - 44/2;
//        [self layoutIfNeeded];
    }
    else{
//        self.btnToken.hidden = false;
        self.btnVanTay.hidden = false;
        self.txtOtp.hidden = true;
        self.lbTime.hidden = true;
        self.lbCountTime.hidden = true;
        self.btnThucHien.hidden = true;
    }
}
- (IBAction)doToken:(id)sender {
    [self.btnToken setSelected:YES];
    [self.btnToken setBackgroundImage:[UIImage imageNamed:@"tokenv"] forState:UIControlStateSelected];
     [self.btnVanTay setSelected:NO];
//    self.btnToken.hidden = false;
    [self.delegate doToken];
}

- (IBAction)doThucHien:(id)sender {
    [self.delegate doThucHien];
}

- (IBAction)doVantay:(id)sender {
    if(self.hasFaceID){
        [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"face_new"] forState:UIControlStateNormal];
        [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"face_new_selected"] forState:UIControlStateSelected];
    }
    else{
        [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
        [self.btnVanTay setBackgroundImage:[UIImage imageNamed:@"fingerv"] forState:UIControlStateSelected];
    }
    [self.btnVanTay setSelected:YES];
    
    [self.btnToken setSelected:NO];
    self.txtOtp.hidden = true;
    self.lbTime.hidden = true;
    self.lbCountTime.hidden = true;
    self.btnThucHien.hidden = true;
    [self.delegate doVanTay];
 
}
@end
