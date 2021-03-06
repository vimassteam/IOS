//
//  HomeCenterViewController.m
//  ViViMASS
//
//  Created by Mac Mini on 9/13/18.
//

#import "HomeCenterViewController.h"
#import "GiaoDienChinhV2.h"
#import "DichVuNotification.h"
#import "HienThiDanhSachTinQuangBaViewController.h"
#import "QRSearchViewController.h"
#import "GiaoDienGioiThieuVi.h"
#import "DucNT_TaiKhoanViObject.h"
#import "GiaoDienThanhToanQRCodeDonVi.h"
#import "GiaoDienThanhToanQRCode.h"
#import "GiaoDienDenKhac.h"
#import "NganhangVC.h"
#import "QRVC.h"
#import "VicuatoiVC.h"
#import "ViDienTuVC.h"
#import "ViewNavigationGiaoDienChinh.h"
#import "FBEncryptorAES.h"
#import "ChuyenTienDienThoaiVC.h"
#import "DucNT_ChuyenTienDenTaiKhoanViewController.h"
#import "DucNT_ChuyenTienDenTheViewController.h"
#import "GiaoDienChuyenTienATM.h"
#import "GiaoDienChuyenTienDenCMND.h"
#import "GuiTietKiemViewController.h"
#import "GiaoDienTraCuuTienVay.h"
#import "ChuyenTienTanNhaViewController.h"
#import "GiaoDienDiemGiaoDichV2.h"
#import "HanMucGiaoDichViewController.h"
#import "ChuyenTienDenViMomoViewController.h"
#import "ChuyenTienViewController.h"
#import "NapViTuTheNganHangViewController.h"
#import "GiaoDienTaiKhoanLienKet.h"
#import "DanhSachQuaTangViewController.h"
#import "DucNT_HienThiTokenViewController.h"
#import "DucNT_DangKyToken.h"
#import "GiaoDienThongTinViDoanhNghiep.h"
#import "DucNT_ChangPrivateInformationViewController.h"
#import "MuonTienViewController.h"
#import "DucNT_SaoKeViewController.h"
#import "GiaoDienTaiKhoanLienKet.h"
#import "DucBT_ShareViewController.h"
#import "GiaoDienGopY.h"
#import "UIButton+WebCache.h"
#import "DucNT_ChuyenTienViDenViViewController.h"
#import "CommonUtils.h"
#import "ChonAnSauDienThoaiViewController.h"
#import "HanMucMoiViewController.h"
#import "Giaodienlienket1ViewController.h"
#import "GiaoDienThanhToanQRVNPay.h"
#import "GiaoDienDiemThanhToanVNPAY.h"
#import "PKIViewController.h"
#import "ViVimass-Swift.h"
#import "QRDonViViewController.h"
@interface HomeCenterViewController ()<UIActionSheetDelegate, QRCodeReaderDelegate,RowSelectDelegate,ViewNavigationGiaoDienChinhDelegate>{
    ViewNavigationGiaoDienChinh *mViewNavigationGiaoDienChinh;
    NSString *keyPin;
    AppDelegate *app;

}
@property (retain,nonatomic) ChuyenTienDienThoaiVC *dienthoaiVC;
@property (retain,nonatomic) NganhangVC *nganhangVC;
@property (retain,nonatomic) ViDienTuVC *vidientuVC;
@property (retain,nonatomic) QRVC *qrVC;
@property (retain,nonatomic) VicuatoiVC *vicuatoiVC;
@property (assign,nonatomic) int currentTab;;

@end

@implementation HomeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    keyPin = @"111111";
    // Do any additional setup after loading the view from its nib.
//    [self.tblContatcs registerNib:[UINib nibWithNibName:@"TblHomeFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TblHomeFooterView"];
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:1];
    
    if (nTongSoLuongTinChuaDoc > 0) {
        [_lblBadgeVi setHidden:NO];
        _lblBadgeVi.text = [NSString stringWithFormat:@"%d", nTongSoLuongTinChuaDoc];
    } else {
        [_lblBadgeVi setHidden:YES];
    }
    
    //NSLog(@"%s - nTongSoLuongTinChuaDoc : %d", __FUNCTION__, nTongSoLuongTinChuaDoc);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuLySuKienDangNhapThanhCong:) name:DANG_NHAP_THANH_CONG object:nil];

    self.mlblThongBaoBadgeNumber.layer.masksToBounds = YES;
    self.mlblThongBaoBadgeNumber.layer.cornerRadius = 12;
    [self.mlblThongBaoBadgeNumber setHidden:YES];
    self.mlblBadgeNumberTroChuyen.layer.masksToBounds = YES;
    self.mlblBadgeNumberTroChuyen.layer.cornerRadius = 12;
    [self.mlblBadgeNumberTroChuyen setHidden:YES];
    self.dienthoaiVC = [[ChuyenTienDienThoaiVC alloc]initWithNibName:@"ChuyenTienDienThoaiVC" bundle:nil];
    self.nganhangVC = [[NganhangVC alloc]initWithNibName:@"NganhangVC" bundle:nil];
    self.nganhangVC.delegate = self;
    self.vidientuVC = [[ViDienTuVC alloc]initWithNibName:@"ViDienTuVC" bundle:nil];
    self.vidientuVC.delegate = self;
    self.qrVC = [[QRVC alloc]initWithNibName:@"QRVC" bundle:nil];
    self.qrVC.delegate = self;
    self.vicuatoiVC = [[VicuatoiVC alloc]initWithNibName:@"VicuatoiVC" bundle:nil];
    self.vicuatoiVC.delegate = self;
    app.selectedTab = 0;
    app.selectedDienThoaiVC = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBackVicuatoi) name:@"ClickVicuatoi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBackSoTay) name:@"ClickBackSoTay" object:nil];
    
    [self updateLangBottomBar];
}

- (void)updateLangBottomBar {
    _lblNganHang.text = [@"btf - transfer btn" localizableString];
    _lblViDienTu.text = [@"vi_khac" localizableString];
//    _lblHoaDon.text = [@"ky_so" localizableString];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self khoiTaoNaviGationBar];
    [self reloadGiaoDien:nil];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNganHang:)];
    tap1.numberOfTapsRequired = 1;
    [self.vNganHang addGestureRecognizer:tap1 ];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViDienTu:)];
    tap2.numberOfTapsRequired = 1;
    [self.vViDienTu addGestureRecognizer:tap2 ];

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQR:)];
    tap3.numberOfTapsRequired = 1;
    [self.vQR addGestureRecognizer:tap3 ];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVicuatoi:)];
    tap4.numberOfTapsRequired = 1;
    [self.vVicuatoi addGestureRecognizer:tap4 ];

    if(app.selectedTab<0){
        self.currentTab = -1;
        [self displayContentController:self.dienthoaiVC];
    }
    else{
        if(app.selectedTab == 0){
            if (self.dienthoaiVC.view.superview) {
                return;
            }
            [self hideContentController:self.dienthoaiVC];
            [self tapNganHang:tap1];
        }
        else if(app.selectedTab == 1){
            [self displayContentController:self.vidientuVC];
        }
        else if(app.selectedTab == 2){
            [self displayContentController:self.qrVC];

        }
        else if(app.selectedTab == 3){
            [self displayContentController:self.vicuatoiVC];

        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    [self xuLyGiaoDienKhiVaoApp];
}

-(void)tapNganHang:(UITapGestureRecognizer*)gesture{
    [self xuLyChonTabNganHang];
}

- (void)xuLyChonTabNganHang {
    [self resetTab];
    app.selectedTab = 0;
    app.selectedDienThoaiVC = 0;
    self.vNganHang.backgroundColor = [UIColor colorWithRed:0/255.0 green:116/255.0 blue:167/255.0 alpha:1.0 ];
    self.vViDienTu.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vVicuatoi.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vQR.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    [self displayContentController:self.nganhangVC];
}

-(void)tapViDienTu:(UITapGestureRecognizer*)gesture{
    //NSLog(@"%s - click vi dien tu : %d", __FUNCTION__, app.selectedTab);
    [self resetTab];
    app.selectedTab = 1;
    app.selectedDienThoaiVC = 0;

    self.vViDienTu.backgroundColor = [UIColor colorWithRed:0/255.0 green:116/255.0 blue:167/255.0 alpha:1.0 ];
    self.vVicuatoi.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vQR.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vNganHang.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    [self displayContentController:self.vidientuVC];

}
-(void)tapQR:(UITapGestureRecognizer*)gesture{
    [self resetTab];
    app.selectedTab = 2;
    app.selectedDienThoaiVC = 0;

    self.vQR.backgroundColor = [UIColor colorWithRed:0/255.0 green:116/255.0 blue:167/255.0 alpha:1.0 ];
    self.vVicuatoi.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vNganHang.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vViDienTu.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    [self displayContentController:self.qrVC];

}
-(void)tapVicuatoi:(UITapGestureRecognizer*)gesture{
    [self resetTab];
    app.selectedTab = 3;
    app.selectedDienThoaiVC = 0;
    self.vVicuatoi.backgroundColor = [UIColor colorWithRed:0/255.0 green:116/255.0 blue:167/255.0 alpha:1.0 ];
    self.vNganHang.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vQR.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    self.vViDienTu.backgroundColor = [UIColor colorWithRed:59/255.0 green:164/255.0 blue:168/255.0 alpha:1.0];
    [self displayContentController:self.vicuatoiVC];

}
-(void)onBackSoTay{
    app.selectedTab = -1;
    if(app.selectedTab<0){
        self.currentTab = -1;
        [self displayContentController:self.dienthoaiVC];
    }
}
-(void)onBackVicuatoi{
    [self tapVicuatoi:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xuLySuKienDangNhapThanhCong:(NSNotification *)notification
{
    [mViewNavigationGiaoDienChinh hienThiBagdeNumber];
    //Cap nhat so du
    //        [self capNhatSoDuVi];
}

- (void)xuLyGiaoDienKhiVaoApp {
    if (self.mThongTinTaiKhoanVi) {
        UIButton * btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTemp.frame = CGRectMake(0, 0, 40, 40);
        [[btnTemp layer] setBorderWidth:2.0f];
        [[btnTemp layer] setBorderColor:[UIColor whiteColor].CGColor];
        [btnTemp.layer setCornerRadius:3.0f];
        if (btnTemp && self.mThongTinTaiKhoanVi) {
            NSString *sDuongDanAnhDaiDien = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien;
            //NSLog(@"%s +++++++++++++++ sDuongDanAnhDaiDien : %@", __FUNCTION__, sDuongDanAnhDaiDien);
            if([sDuongDanAnhDaiDien isEqualToString:@""])
            {
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"icon_danhba"] forState:UIControlStateNormal];
            }
            else
            {
                if([sDuongDanAnhDaiDien rangeOfString:@"http"].location != NSNotFound){
                    [btnTemp sd_setBackgroundImageWithURL:[NSURL URLWithString:sDuongDanAnhDaiDien] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_danhba"]];
                }
                else{
                    [btnTemp sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://vimass.vn/vmbank/services/media/getImage?id=%@", sDuongDanAnhDaiDien]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_danhba"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        //NSLog(@"%s - error : %@", __FUNCTION__, error);
                        //NSLog(@"%s - imageURL : %@", __FUNCTION__, imageURL);
                        
                    }];
                }
            }
        }
        
        btnTemp.backgroundColor = [UIColor clearColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
            [btnTemp.widthAnchor constraintEqualToConstant:40].active = YES;
            [btnTemp.heightAnchor constraintEqualToConstant:40].active = YES;
        }
        [btnTemp addTarget:self action:@selector(suKienBamNutMore:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnTemp];
        self.navigationItem.rightBarButtonItem = leftItem;

        [self capNhatSoDuVi];
    }
    else {
        [self addButton:@"icon_more" selector:@selector(suKienBamNutMore:) atSide:1];
//        NSString *sKeyDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
        //NSLog(@"%s - sKeyDangNhap : %@", __FUNCTION__, sKeyDangNhap);
//        if(sKeyDangNhap.length > 0)
//        {
//            NSDictionary *dict = [sKeyDangNhap objectFromJSONString];
//            NSArray *arrTemp = [dict allKeys];
//            if (arrTemp != nil && arrTemp.count > 0) {
////                NSString *sTaiKhoan = (NSString *)[arrTemp firstObject];
//                //NSLog(@"%s - tai khoan : %@", __FUNCTION__, sTaiKhoan);
////                [self hienThongBaoDangNhapVanTay:sTaiKhoan];
//            }
//        }
    }
}

- (void)khoiTaoNaviGationBar
{
    if (mViewNavigationGiaoDienChinh == nil) {
        mViewNavigationGiaoDienChinh = [[[NSBundle mainBundle] loadNibNamed:@"ViewNavigationGiaoDienChinh" owner:self options:nil] objectAtIndex:0];
        mViewNavigationGiaoDienChinh.mDelegate = self;
        self.navigationItem.titleView = mViewNavigationGiaoDienChinh;
        
        UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLeft addTarget:self action:@selector(suKienBamNutHome:) forControlEvents:UIControlEventTouchUpInside];
        [btnLeft setImage:[UIImage imageNamed:@"ic_home_32"] forState:UIControlStateNormal];
        [btnLeft.widthAnchor constraintEqualToConstant:25].active = YES;
        [btnLeft.heightAnchor constraintEqualToConstant:25].active = YES;
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.leftBarButtonItem = leftBtn;
        //        [self addButton:@"ic_home_32" selector:@selector(suKienBamNutHome :) atSide:0];
    }
}

- (void)hienThongBaoDangNhapVanTay:(NSString *)taiKhoan {
    LAContext *context = [[[LAContext alloc] init] autorelease];
    NSError *err = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
    {
        if (@available(iOS 11.0, *)) {
            [self hienThiLoading];
        }
        else {
            [RoundAlert show];
        }
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:[NSString stringWithFormat:@"Đăng nhập tài khoản : %@", taiKhoan]
                          reply:^(BOOL success, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     if (@available(iOS 11.0, *)) {
                         [self anLoading];
                     }
                     else {
                         [RoundAlert hide];
                     }
                     [self hienThiHopThoaiMotNutBamKieu:-1 cauThongBao:@"Có lỗi khi đăng nhập bằng vân tay. Vui lòng thử lại sau."];
                     return;
                 }
                 if(success)
                 {
                     [self xuLySuKienXacThucVanTayThanhCong];
                 }
             });
         }];
    }
}

- (void)xuLySuKienXacThucVanTayThanhCong
{
    NSString *sDictDangNhap = [DucNT_LuuRMS layThongTinDangNhap:KEY_DANG_NHAP];
    NSDictionary *dictDangNhap = [sDictDangNhap objectFromJSONString];
    NSArray *arrTemp = [dictDangNhap allKeys];
    if (arrTemp != nil && arrTemp.count > 0) {
        NSString *sTaiKhoan = (NSString *)[arrTemp firstObject];
        NSString *sMatKhauMaHoa = [dictDangNhap valueForKey:sTaiKhoan];
        NSString *sMatKhauGiaiMa = [self giaiMa:sMatKhauMaHoa];
        self.mDinhDanhKetNoi = @"DANG_NHAP_VAN_TAY";
        [GiaoDichMang ketNoiDangNhapTaiKhoanViViMASS:sTaiKhoan matKhau:sMatKhauGiaiMa maDoanhNghiep:@"" noiNhanKetQua:self];
    }
}

- (NSString*)giaiMa:(NSString*)s
{
    NSString *s1 = [FBEncryptorAES decryptBase64String:s keyString:keyPin];
    return s1;
}

- (void)capNhatSoDuVi
{
    if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
    {
        //NSLog(@"%s - ============> DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN", __FUNCTION__);
        self.mDinhDanhKetNoi = DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN;
        [GiaoDichMang ketNoiLaySoDuTaiKhoan:self];
    }
    else {
    }
}


#pragma mark - DucNT_ServicePostDelegate

- (void)ketNoiThanhCong:(NSString *)sKetQua {
    NSDictionary *dicKetQua = [sKetQua objectFromJSONString];
    int nCode = [[dicKetQua objectForKey:@"msgCode"] intValue];
    NSString *message = [dicKetQua objectForKey:@"msgContent"];
    id result = [dicKetQua objectForKey:@"result"];
    if (nCode == 1) {
        [self xuLyKetNoiThanhCong:self.mDinhDanhKetNoi thongBao:message ketQua:result];
    }
    else {
        [self xuLyKetNoiThatBai:self.mDinhDanhKetNoi thongBao:message ketQua:result];
    }
}

- (void)xuLyKetNoiThanhCong:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    //NSLog(@"%s - nhan ket qua thanh cong : %@", __FUNCTION__, sDinhDanhKetNoi);
    if ([sDinhDanhKetNoi isEqualToString:@"LAY_THONG_TIN_QR"]) {
            NSDictionary *dictKetQua = (NSDictionary*)ketQua;
            int maDonViCapQR = [[dictKetQua objectForKey:@"maDonViCapQR"] intValue];
            if (maDonViCapQR == 0) {
                NSString *sChiTiet = (NSString *)dictKetQua[@"chiTiet"];
                GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
                vc.sIdQRCode = sChiTiet;
                if ([sChiTiet hasPrefix:@"V"]) {
                    vc.typeQRCode = 1;
                } else {
                    vc.typeQRCode = 0;
                }
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            } else if (maDonViCapQR == 1 || maDonViCapQR == 3) {
//                GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
//                if (maDonViCapQR == 3) {
//                    NSString * chiTiet = [dictKetQua objectForKey:@"chiTiet"];
//                    NSLog(@"HomeCenterViewController - %s - chiTiet : %@", __FUNCTION__, chiTiet);
//                    NSDictionary *dictTemp = [chiTiet objectFromJSONString];
//                    vc.dictChiTiet = [[NSDictionary alloc] initWithDictionary:dictTemp];
//                    vc.maDonViCapQR = 3;
//                } else {
//                    NSDictionary *dictChiTiet = (NSDictionary *)dictKetQua[@"chiTiet"];
//                    NSString *sMaGiaoDich = (NSString *)[dictChiTiet objectForKey:@"maGiaoDich"];
//                    vc.dictChiTiet = [[NSDictionary alloc] initWithDictionary:dictChiTiet];
//                    vc.sMaGiaoDich = sMaGiaoDich;
//                    vc.maDonViCapQR = 1;
//                }
//                self.navigationController.navigationBar.hidden = NO;
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
            } else if (maDonViCapQR == 4) {
                NSDictionary *dictChiTiet = (NSDictionary *)dictKetQua[@"chiTiet"];
                NSString *sDictChiTiet = [dictChiTiet JSONString];
                [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:sDictChiTiet];
                GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
    //        GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
    //        self.navigationController.navigationBar.hidden = NO;
    //        [self.navigationController pushViewController:vc animated:YES];
    //        [vc release];
    //        NSString *sChiTiet = (NSString *)dictKetQua[@"chiTiet"];
    //        if (![sChiTiet isEmpty]) {
    //            [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:sChiTiet];
    //
    //        }
        }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_SO_DU_TAI_KHOAN])
    {
        NSDictionary *dictResult = (NSDictionary *)ketQua;
        NSNumber *nAmount = [dictResult objectForKey:@"amount"];
        NSNumber *promotionTotal = [dictResult objectForKey:@"promotionTotal"];
        NSNumber *promotionStatus = [dictResult objectForKey:@"promotionStatus"];
        NSNumber *totalCreateGift = [dictResult objectForKey:@"totalCreateGift"];
        NSNumber *totalGift = [dictResult objectForKey:@"totalGift"];
        
        if(nAmount) { 
            self.mThongTinTaiKhoanVi.nAmount = nAmount;
        }
        if(promotionStatus) {
            self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
        }
        if(promotionTotal) {
            self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
        }
        if(totalCreateGift) {
            self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
        }
        if(totalCreateGift) {
            self.mThongTinTaiKhoanVi.toTalGift = totalGift;
        }
        
        self.mThongTinTaiKhoanVi.nPromotionStatus = promotionStatus;
        self.mThongTinTaiKhoanVi.nPromotionTotal = promotionTotal;
        self.mThongTinTaiKhoanVi.totalCreateGift = totalCreateGift;
        self.mThongTinTaiKhoanVi.toTalGift = totalGift;
        [mViewNavigationGiaoDienChinh hienThiSoTien:[NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]]]];
      
//        [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
        //NSLog(@"%s - vao den day", __FUNCTION__);
    }
    else if ([sDinhDanhKetNoi isEqualToString:DINH_DANH_KET_NOI_LAY_QUANG_CAO]) {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamnv_hienthi"];
        //NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, value);
        //NSLog(@"%s - %s : ==========> value : %@", __FILE__, __FUNCTION__, ketQua);
        
        NSArray *dictResult = (NSArray *)ketQua;
        NSString *sQC = [dictResult JSONString];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:sQC forKey:@"QUANG_CAO_VI_VIMASS"];
        [user synchronize];
        //NSLog(@"%s - dictResult : %ld", __FUNCTION__, (long)dictResult.count);
        
        NSMutableArray *arrQC = [[NSMutableArray alloc] init];
        for (NSDictionary *dicTemp in dictResult) {
            
            int nVMApp = [[dicTemp objectForKey:@"VMApp"] intValue];
            NSString *nameImage = (NSString *)[dicTemp objectForKey:@"nameImage"];
            if (nVMApp == 1 && ![nameImage containsString:@"mua mã thẻ"] && ![nameImage containsString:@"FPT"]) {
                [arrQC addObject:dicTemp];
            }
        }
    }
    else if ([sDinhDanhKetNoi isEqualToString:@"DANG_NHAP_VAN_TAY"]) {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        NSDictionary *dicKQ2 = (NSDictionary *)ketQua;
        self.mThongTinTaiKhoanVi = [[DucNT_TaiKhoanViObject alloc] initWithDict:dicKQ2];
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_ID_TEMP value:self.mThongTinTaiKhoanVi.sID];
        self.mDinhDanhKetNoi = DINH_DANH_DANG_KI_THIET_BI;
        
        NSString *sDeviceToken = [DucNT_LuuRMS layThongTinDangNhap:KEY_DEVICE_TOKEN];
        //NSLog(@"%s - sDeviceToken : %@", __FUNCTION__, sDeviceToken);
        if(sDeviceToken.length > 0)
        {
            NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
            if(sTaiKhoan.length == 0)
                sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];
            
            if(sTaiKhoan.length > 0)
            {
                NSDictionary *dicPost = @{
                                          @"deviceId":sDeviceToken,
                                          @"id":@"",
                                          @"deviceOS":@"2",
                                          @"phone":sTaiKhoan,
                                          @"appId":[NSString stringWithFormat:@"%d", APP_ID]
                                          };
                //NSLog(@"%s - [dicPost JSONString] : %@", __FUNCTION__, [dicPost JSONString]);
                DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
                NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"addDevice"];
                [connectUpDeviceToken connect:sUrl withContent:[dicPost JSONString]];
                connectUpDeviceToken.ducnt_connectDelegate = self;
                [connectUpDeviceToken release];
            }
        }
        else {
            [self xuLySauKhiDangKyThietBi:nKieuDangNhap];
        }
    }
    else if([sDinhDanhKetNoi isEqualToString:DINH_DANH_DANG_KI_THIET_BI])
    {
        int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
        [self xuLySauKhiDangKyThietBi:nKieuDangNhap];
    }
}

- (void)xuLySauKhiDangKyThietBi:(int)nKieuDangNhap {
    [DucNT_LuuRMS luuThongTinTaiKhoanViSauDangNhap:self.mThongTinTaiKhoanVi];
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"YES"];
    [self xuLyGiaoDienKhiVaoApp];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:DANG_NHAP_THANH_CONG object:nil];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadGiaoDienHome];
    if (@available(iOS 11.0, *)) {
        [self anLoading];
    }
    else {
        [RoundAlert hide];
    }
}

- (void)xuLyKetNoiThatBai:(NSString *)sDinhDanhKetNoi thongBao:(NSString *)sThongBao ketQua:(id)ketQua {
    if (@available(iOS 11.0, *)) {
        [self anLoading];
    }
    else {
        [RoundAlert hide];
    }
}


// For Navigate


- (IBAction)suKienBamNutHome:(UIButton *)sender
{
    [self xuLyChonTabNganHang];
//    [self resetTab];
//    [self displayContentController:self.dienthoaiVC];
}

- (void)xuLySuKienBamNutQR:(int)type{
    NSLog(@"%s - type : %d", __FUNCTION__, type);
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        QRSearchViewController *vcQRCodeTemp = [[QRSearchViewController alloc]initWithNibName:@"QRSearchViewController" bundle:nil];
        vcQRCodeTemp.codeReader = reader;
        vcQRCodeTemp.modalPresentationStyle = UIModalPresentationFormSheet;
        vcQRCodeTemp.delegate = self;
        vcQRCodeTemp.nType = type;
        [self presentViewController:vcQRCodeTemp animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Thiết bị không hỗ trợ chức năng này." delegate:nil cancelButtonTitle:@"Đóng" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)xuLySuKienBamNutQR {
    NSLog(@"%s - click click", __FUNCTION__);
//    [self xuLySuKienBamNutQR:1];
    [self xuLySuKienBamNutQR:1];
}

- (void)xuLySuKienBamNutSaoKe {
    NSLog(@"%s - click click", __FUNCTION__);
    GiaoDienHuongDanViewController *vc = [[GiaoDienHuongDanViewController alloc] initWithNibName:@"GiaoDienHuongDanViewController" bundle:nil];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
}


- (void)xuLySuKienBamNutThongBao {
    HienThiDanhSachTinQuangBaViewController *hienThiTinQuangBaViewController = [[HienThiDanhSachTinQuangBaViewController alloc] initWithNibName:@"HienThiDanhSachTinQuangBaViewController" bundle:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:hienThiTinQuangBaViewController animated:YES];
    [hienThiTinQuangBaViewController release];
}

- (IBAction)suKienBamNutSaoKe:(id)sender {
    GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

- (IBAction)suKienBamNutMore:(UIButton *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleCancel handler:nil]];
    NSString *sDangNhap =  [@"Logout" localizableString];
    if (self.mThongTinTaiKhoanVi == nil) {
        sDangNhap = [@"dang_nhap" localizableString];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:sDangNhap style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self suKienDangXuat];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[@"share" localizableString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DucBT_ShareViewController *shareViewController = [[DucBT_ShareViewController alloc] initWithNibName:@"DucBT_ShareViewController" bundle:nil];
        [self.navigationController pushViewController:shareViewController animated:YES];
        [shareViewController release];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[@"gop_y" localizableString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GiaoDienGopY *gopY = [[GiaoDienGopY alloc] initWithNibName:NSStringFromClass([GiaoDienGopY class]) bundle:nil];
        [self.navigationController pushViewController:gopY animated:YES];
        [gopY release];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[@"huong_dan" localizableString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
        vc.nType = 3;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Đóng" destructiveButtonTitle:nil otherButtonTitles:[@"Logout" localizableString], [@"share" localizableString], [@"gop_y" localizableString], [@"huong_dan" localizableString], nil];
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.mThongTinTaiKhoanVi) {
        NSLog(@"%s - buttonIndex : %d", __FUNCTION__, (int)buttonIndex);
        if (buttonIndex == 0) {
            [self suKienDangXuat];
        }
        else if (buttonIndex == 1){
            DucBT_ShareViewController *shareViewController = [[DucBT_ShareViewController alloc] initWithNibName:@"DucBT_ShareViewController" bundle:nil];
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }
        else if (buttonIndex == 2) {
            GiaoDienGopY *gopY = [[GiaoDienGopY alloc] initWithNibName:NSStringFromClass([GiaoDienGopY class]) bundle:nil];
            [self.navigationController pushViewController:gopY animated:YES];
            [gopY release];
        }
        else if (buttonIndex == 3){
            GiaoDienGioiThieuVi *vc = [[GiaoDienGioiThieuVi alloc] initWithNibName:@"GiaoDienGioiThieuVi" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
}

- (void)suKienDangXuat
{
    NSString *sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP];
    if(sTaiKhoan.length == 0)
        sTaiKhoan = [DucNT_LuuRMS layThongTinDangNhap:KEY_LAST_ID_LOGIN];

    if(sTaiKhoan.length > 0)
    {
        NSDictionary *dicPost = @{
                                  @"deviceId":@"123456789012345",
                                  @"id":@"",
                                  @"deviceOS":@"2",
                                  @"phone":sTaiKhoan,
                                  @"appId":[NSString stringWithFormat:@"%d", APP_ID]
                                  };
        NSLog(@"%s - [dicPost JSONString] : %@", __FUNCTION__, [dicPost JSONString]);
        DucNT_ServicePost *connectUpDeviceToken = [[DucNT_ServicePost alloc] init];
        NSString *sUrl = [NSString stringWithFormat:@"%@/%@", BASE_URL_SERVICE_NOTIFICATION, @"addDevice"];
        [connectUpDeviceToken connect:sUrl withContent:[dicPost JSONString]];
//        connectUpDeviceToken.ducnt_connectDelegate = self;
        [connectUpDeviceToken release];
    }
    
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LOGIN_STATE value:@"NO"];
    
    [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_ID_LOGIN value:sTaiKhoan];
    
    int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
    if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
    {
        sTaiKhoan = self.mThongTinTaiKhoanVi.walletLogin;
    }
    
    if(sTaiKhoan.length == 10 || sTaiKhoan.length == 11)
    {
        [DucNT_LuuRMS luuThongTinDangNhap:KEY_LAST_PHONE_LOGIN_ID value:sTaiKhoan];
    }
    //Xoa bagde number o icon tren man hinh iPhone
    [[DichVuNotification shareService] dichVuXacNhanDaDocTatCaCacTin];
    int nTongSoLuongTinChuaDoc = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTongSoLuongTinChuaDoc];
    [app showLogin];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRSearchViewController *)reader didScanResultSearch:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"%s - --> line : %d - result : %@", __FUNCTION__, __LINE__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dic = @{
                              @"dataQR": result,
                              @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
        self.mDinhDanhKetNoi = @"LAY_THONG_TIN_QR";
        [self hienThiLoading];
        [GiaoDichMang ketNoiLayThongTinQR:[dic JSONString] noiNhanKetQua:self];
//        if (![[result lowercaseString] containsString:@"http"] && ![[result lowercaseString] containsString:@"vimass"] && result.length > 20) {
//            //NSLog(@"%s - chuyen huong vnpay QR", __FUNCTION__);
//            GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
//            vc.sDataQR = result;
//            self.navigationController.navigationBar.hidden = NO;
//            [self.navigationController pushViewController:vc animated:YES];
//            [vc release];
//        } else {
//            NSArray *arrResult = [result componentsSeparatedByString:@"*"];
//            //NSLog(@"%s - arrResult : %lu", __FUNCTION__, (unsigned long)arrResult.count);
//            if (arrResult.count > 2) {
//                NSString *str = arrResult[1];
//                NSLog(@"%s ----> str : %@", __FUNCTION__, str);
//                if ([str hasPrefix:@"V"] || [str hasPrefix:@"S"]) {
//                    NSLog(@"%s - line : %d", __FUNCTION__, __LINE__);
//                    [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:str];
//                    GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
//                    self.navigationController.navigationBar.hidden = NO;
//                    [self.navigationController pushViewController:vc animated:YES];
//                    [vc release];
//                }
//                else if ([str hasPrefix:@"M"]){
//                    NSLog(@"%s - line : %d", __FUNCTION__, __LINE__);
//                }
//                else{
//                }
//            } else {
//                [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:result];
//                GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
//                self.navigationController.navigationBar.hidden = NO;
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
//            }
//        }
    }];
}
- (void)reader:(QRSearchViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"%s - --> line : %d - result : %@", __FUNCTION__, __LINE__, result);
    [reader dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dic = @{
                              @"dataQR": result,
                              @"user" : [DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_ID_TEMP],
                              @"appId" : [NSString stringWithFormat:@"%d", APP_ID],
                              @"VMApp" : [NSNumber numberWithInt:VM_APP]
                              };
        NSLog(@"%s - dic : %@", __FUNCTION__, [dic JSONString]);
        self.mDinhDanhKetNoi = @"LAY_THONG_TIN_QR";
        [self hienThiLoading];
        [GiaoDichMang ketNoiLayThongTinQR:[dic JSONString] noiNhanKetQua:self];
//        if (result.length > 0) {
//            if (![[result lowercaseString] containsString:@"http"] && ![[result lowercaseString] containsString:@"vimass"] && result.length > 20) {
//                //NSLog(@"%s - chuyen huong vnpay QR", __FUNCTION__);
//                GiaoDienThanhToanQRVNPay *vc = [[GiaoDienThanhToanQRVNPay alloc] initWithNibName:@"GiaoDienThanhToanQRVNPay" bundle:nil];
//                vc.sDataQR = result;
//                self.navigationController.navigationBar.hidden = NO;
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
//            } else {
//                if (![result hasPrefix:@"http"] || [result hasSuffix:@"/transfers"]) {
//                    if ([result containsString:@"*"]) {
//                        NSArray *arrQuery = [result componentsSeparatedByString:@"*"];
//                        if (arrQuery.count > 2) {
//                            [DucNT_LuuRMS luuThongTinTrongRMSTheoKey:@"KEY_QR_SAN_PHAM_VER_2" value:[arrQuery objectAtIndex:1]];
//                            GiaoDienThanhToanQRSanPham *vc = [[GiaoDienThanhToanQRSanPham alloc] initWithNibName:@"GiaoDienThanhToanQRSanPham" bundle:nil];
//                            self.navigationController.navigationBar.hidden = NO;
//                            [self.navigationController pushViewController:vc animated:YES];
//                            [vc release];
//                        }
//                    }
//                }
//                else {
//                    NSURL *url = [NSURL URLWithString:result];
//                    NSString *queryQRCode = url.query;
//                    //NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
//                    if (queryQRCode == nil && [[url lastPathComponent] isEqualToString:@"quickpay"]) {
////                        GiaoDienThanhToanQRCodeDonVi *vc = [[GiaoDienThanhToanQRCodeDonVi alloc] initWithNibName:@"GiaoDienThanhToanQRCodeDonVi" bundle:nil];
////                        if ([[url lastPathComponent] isEqualToString:@"quickpay"]) {
////                            NSString *sKQ = [result stringByReplacingOccurrencesOfString:@"/quickpay" withString:@""];
////                            NSURL *url1 = [NSURL URLWithString:sKQ];
////                            vc.sIdQRCode = [url1 lastPathComponent];
////                        } else {
////                            vc.sIdQRCode = [url lastPathComponent];
////                        }
////                        vc.typeQRCode = 0;
////                        self.navigationController.navigationBar.hidden = NO;
////                        [self.navigationController pushViewController:vc animated:YES];
////                        [vc release];
//                    }
//                    else {
//                        //NSLog(@"%s - -->queryQRCode : %@", __FUNCTION__, queryQRCode);
//                        NSArray *arrQuery = [queryQRCode componentsSeparatedByString:@"="];
//                        if (arrQuery.count == 2) {
//                            NSString *idQRCode = [arrQuery lastObject];
//                            //NSLog(@"%s - -->idQRCode : %@", __FUNCTION__, idQRCode);
//                            GiaoDienThanhToanQRCode *vc = [[GiaoDienThanhToanQRCode alloc] initWithNibName:@"GiaoDienThanhToanQRCode" bundle:nil];
//                            vc.sIdQRCode = idQRCode;
//                            [self.navigationController pushViewController:vc animated:YES];
//                            self.navigationController.navigationBar.hidden = NO;
//                            [vc release];
//                        }
//                    }
//                }
//            }
//        }
         
    }];
}

- (void)readerDidCancel:(QRSearchViewController *)reader
{
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)reloadGiaoDien:(NSNotification *)notification{
    //NSLog(@"%s =========================================>", __FUNCTION__);
    [self hienThiBagdeNumber];
    if (self.mThongTinTaiKhoanVi) {
        [self hienThiSoTien:[NSString stringWithFormat:@"%@ đ", [Common hienThiTienTe:[self.mThongTinTaiKhoanVi.nAmount doubleValue]]]];
    }
    else {
        [self hienThiSoTien:@""];
    }
    //    int nBagdeNumber = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_TAI_CHINH];
}

- (void)hienThiBagdeNumber
{
    if (mViewNavigationGiaoDienChinh != nil) {
        int nBagdeNumberQuangBa = [[DichVuNotification shareService] laySoLuongTinChuaDocTrongChucNang:TIN_QUANG_BA];
//        int nBagdeNumberQuangBa = 10;
        //NSLog(@"%s - nBagdeNumberQuangBa : %d", __FUNCTION__, nBagdeNumberQuangBa);
        if(nBagdeNumberQuangBa > 0)
        {
            mViewNavigationGiaoDienChinh.mlblThongBaoBadgeNumber.text = [NSString stringWithFormat:@"%d", nBagdeNumberQuangBa];
            [mViewNavigationGiaoDienChinh.mlblThongBaoBadgeNumber setHidden:NO];
//            [self.mlblThongBaoBadgeNumber setText:[NSString stringWithFormat:@"%d", nBagdeNumberQuangBa]];
//            [self.mlblThongBaoBadgeNumber setHidden:NO];
        }
        else
        {
            [mViewNavigationGiaoDienChinh.mlblThongBaoBadgeNumber setHidden:YES];
//            [self.mlblThongBaoBadgeNumber setHidden:YES];
        }
    }
    
}

- (void)hienThiSoTien:(NSString *)sSoTien {
    CGRect rectChinh = self.lblChinh.frame;
    if (sSoTien.length > 0) {
        rectChinh.size.height = 21;
    }
    else {
        rectChinh.size.height = 44;
    }
    self.lblChinh.frame = rectChinh;
    self.lblSoDu.text = sSoTien;
}

- (IBAction)onNext:(id)sender {
    GiaoDienChinhV2 *giaodienv2VC = [[GiaoDienChinhV2 alloc]initWithNibName:@"GiaoDienChinhV2" bundle:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:giaodienv2VC animated:YES];
}
- (void)showStatusInprogressDev{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"Tính năng đang phát triển" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:okAction];
//    [okAction release];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
//    [alertVC release];
}
-(void)didSelectRow:(int)row withTab:(int)tab{
    app.selectedTab = tab;
    if(tab == 0){
        switch (row) {
            case 0:
            {
                DucNT_ChuyenTienViDenViViewController *vc = [[DucNT_ChuyenTienViDenViViewController alloc]initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 1:{
                [self resetTab];
                [self displayContentController:self.dienthoaiVC];
            }
                
                break;
            case 2:{
                self.navigationController.navigationBar.hidden = false;
                DucNT_ChuyenTienDenTaiKhoanViewController *vc = [[DucNT_ChuyenTienDenTaiKhoanViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTaiKhoanViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                
                break;
            case 3:
            {
                DucNT_ChuyenTienDenTheViewController *vc = [[DucNT_ChuyenTienDenTheViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTheViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 4:
            {
                GiaoDienChuyenTienATM *vc = [[GiaoDienChuyenTienATM alloc] initWithNibName:@"GiaoDienChuyenTienATM" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 5:{
                ChuyenTienTanNhaViewController *vc = [[ChuyenTienTanNhaViewController alloc] initWithNibName:@"ChuyenTienTanNhaViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
                }
                break;
            case 6:
            {
                GiaoDienChuyenTienDenCMND *vc = [[GiaoDienChuyenTienDenCMND alloc] initWithNibName:@"GiaoDienChuyenTienDenCMND" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 7:
            {
                GuiTietKiemViewController *vc = [[GuiTietKiemViewController alloc] initWithNibName:@"GuiTietKiemViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
//                GiaoDienTraCuuTienVay *vc = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
            }
                break;
            case 8:
            {
//                GiaoDienDiemGiaoDichV2 *vc = [[GiaoDienDiemGiaoDichV2 alloc] initWithNibName:@"GiaoDienDiemGiaoDichV2" bundle:nil];
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    HanMucMoiViewController *vc = [[HanMucMoiViewController alloc] initWithNibName:@"HanMucMoiViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else
                {
                    DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                    loginSceen.sTenViewController = @"DucNT_HienThiTokenViewController";
                    loginSceen.sKieuChuyenGiaoDien = @"push";
                    [self.navigationController pushViewController:loginSceen animated:YES];
                    [loginSceen release];
                }
            }
                break;
            case 9:
            {
                if([self.mThongTinTaiKhoanVi.nIsToken intValue] != 0)
                {
                    DucNT_HienThiTokenViewController *hienThiTokenViewController = [[DucNT_HienThiTokenViewController alloc] initWithNibName:@"DucNT_HienThiTokenViewController" bundle:nil];
                    [self.navigationController pushViewController:hienThiTokenViewController animated:YES];
                    [hienThiTokenViewController release];
                }
                else
                {
                    DucNT_DangKyToken *vc = [[DucNT_DangKyToken alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
            }
                break;
            default:
                break;
        }
    }
    else if(tab == 1){
        if (row == 4) {
            DucNT_ChuyenTienDenTheViewController *vc = [[DucNT_ChuyenTienDenTheViewController alloc] initWithNibName:@"DucNT_ChuyenTienDenTheViewController" bundle:nil];
            vc.nOption = 1;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } else {
            self.navigationController.navigationBar.hidden = false;
            ChuyenTienDenViMomoViewController *vc = [[ChuyenTienDenViMomoViewController alloc] initWithNibName:@"ChuyenTienDenViMomoViewController" bundle:nil];
            if (row == 0) {
                //air pay
                vc.nType = 8;
            } else if (row == 1) {
                //momo
                vc.nType = 1;
            }else if (row == 2) {
                //ngan luong
                vc.nType = 2;
            }
            else if (row == 3) {
                vc.nType = 3;//Paypoo
            }
            else if (row == 5) {
                vc.nType = 4;//vimo
            }else if (row == 6) {
                vc.nType = 6;//vi viet
            }else if (row == 7) {
                vc.nType = 7;//vnpt pay
            }
            else if (row == 8) {
                // VTC PAY
                vc.nType = 5;
            }
            else if (row == 9) {
                vc.nType = 9;
            }
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
    else if (tab == 2){
        switch(row){
            case 0:{
                [self xuLySuKienBamNutQR:1];
                break;
            }
            case 1:{
                QRDonViViewController *vc = [[QRDonViViewController alloc] initWithNibName:@"QRDonViViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
                break;
            }
            case 2:{
                GiaoDienDiemThanhToanVNPAY *vc = [[GiaoDienDiemThanhToanVNPAY alloc] initWithNibName:@"GiaoDienDiemThanhToanVNPAY" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
                break;
            }
            default:{
                [self showStatusInprogressDev];
            }break;
        }
    }
    else if (tab == 3){
        self.navigationController.navigationBar.hidden = false;
        switch (row) {
            case 0:{
                // sao ke
                [_lblBadgeVi setHidden:YES];
                DucNT_SaoKeViewController *saoKeViewController = [[DucNT_SaoKeViewController alloc] initWithNibName:@"DucNT_SaoKeViewController" bundle:nil];
                saoKeViewController.nTrangThaiXem = SAO_KE_VI;
                [self.navigationController pushViewController:saoKeViewController animated:YES];
                [saoKeViewController release];
            }
                break;
//            case 1:{
//                // chuyen tien den vi vimass
//                DucNT_ChuyenTienViDenViViewController *vc = [[DucNT_ChuyenTienViDenViViewController alloc]initWithNibName:@"DucNT_ChuyenTienViDenViViewController" bundle:nil];
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc release];
//            }
//                break;
            case 1:{
                Giaodienlienket1ViewController * vc = [[Giaodienlienket1ViewController alloc] initWithNibName:@"Giaodienlienket1ViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
                break;
            case 2:{
                ChonAnSauDienThoaiViewController * vc = [[ChonAnSauDienThoaiViewController alloc] initWithNibName:@"ChonAnSauDienThoaiViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
//                [self resetTab];
//                [self displayContentController:self.dienthoaiVC];
            }
                break;
            case 3:{
                // nap tien
                NapViTuTheNganHangViewController *napViTuTheNganHangViewController = [[NapViTuTheNganHangViewController alloc] initWithNibName:@"NapViTuTheNganHangViewController" bundle:nil];
                [self.navigationController pushViewController:napViTuTheNganHangViewController animated:YES];
                [napViTuTheNganHangViewController release];
                
            }
                break;
            case 4:{
                // rut tien
                ChuyenTienViewController *chuyenTienViewController = [[ChuyenTienViewController alloc] initWithNibName:@"ChuyenTienViewController" bundle:nil];
                [self.navigationController pushViewController:chuyenTienViewController animated:YES];
                [chuyenTienViewController release];
            }
                break;
            case 5:{
                // muon tien
                MuonTienViewController *muonTienViewController = [[MuonTienViewController alloc] initWithNibName:@"MuonTienViewController" bundle:nil];
                [self.navigationController pushViewController:muonTienViewController animated:YES];
                [muonTienViewController release];
            }
                break;
            case 6:{
                // thay doi thogn tin
                GiaoDienTraCuuTienVay *vc = [[GiaoDienTraCuuTienVay alloc] initWithNibName:@"GiaoDienTraCuuTienVay" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];

            }
                break;
            case 8:{
                // han muc
                if([[DucNT_LuuRMS layThongTinDangNhap:KEY_LOGIN_STATE] boolValue])
                {
                    HanMucMoiViewController *vc = [[HanMucMoiViewController alloc] initWithNibName:@"HanMucMoiViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                else
                {
                    DucNT_LoginSceen *loginSceen = [[DucNT_LoginSceen alloc] initWithNibName:@"DucNT_LoginSceen" bundle:nil];
                    loginSceen.sTenViewController = @"DucNT_HienThiTokenViewController";
                    loginSceen.sKieuChuyenGiaoDien = @"push";
                    [self.navigationController pushViewController:loginSceen animated:YES];
                    [loginSceen release];
                }
            }
                break;
            case 7:{
                int nKieuDangNhap = [[DucNT_LuuRMS layThongTinDangNhap:KEY_HIEN_THI_VI] intValue];
                if(nKieuDangNhap == KIEU_DOANH_NGHIEP)
                {
                    GiaoDienThongTinViDoanhNghiep *info = [[GiaoDienThongTinViDoanhNghiep alloc] initWithNibName:@"GiaoDienThongTinViDoanhNghiep" bundle:nil];
                    [self.navigationController pushViewController:info animated:YES];
                    [info release];
                }
                else{
                    DucNT_ChangPrivateInformationViewController *thayDoiThongTinCaNhan = [[DucNT_ChangPrivateInformationViewController alloc] initWithNibName:@"DucNT_ChangPrivateInformationViewController" bundle:nil];
                    [self.navigationController pushViewController:thayDoiThongTinCaNhan animated:YES];
                    [thayDoiThongTinCaNhan release];
                }
            }
                break;
            default:
                break;
        }
    }
}

-(void)resetTab{
    if (app.selectedTab == -1) {
        [self hideContentController:self.dienthoaiVC];
    }
    else if (app.selectedTab == 0){
        [self hideContentController:self.nganhangVC];
    }
    if (app.selectedTab == 1) {
        [self hideContentController:self.vidientuVC];
    }
    else if (app.selectedTab == 2){
        [self hideContentController:self.qrVC];
    }
    else if (app.selectedTab == 3){
        [self hideContentController:self.vicuatoiVC];
    }
}
- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];                 // 1
    content.view.frame = self.vCenter.bounds;                 //2
    [self.vCenter addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

- (void) hideContentController: (UIViewController*) content
{
    //NSLog(@"%s - remove view ngan hang", __FUNCTION__);
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.dienthoaiVC release];
    [_vNganHang release];
    [_vViDienTu release];
    [_vQR release];
    [_vVicuatoi release];
    [_vCenter release];
    [_btnNganHang release];
    [_btnViDienTu release];
    [_btnQR release];
    [_btnViCuaToi release];
    [_lblNganHang release];
    [_lblViDienTu release];
    [_lblHoaDon release];
    [_lblViVimass release];
    [_lblBadgeVi release];
    [super dealloc];
}

@end
