//
//  HanMucMoiViewController.m
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/15/18.
//

#import "HanMucMoiViewController.h"

@interface HanMucMoiViewController ()

@end

@implementation HanMucMoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hạn mức";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.scrMain.subviews containsObject:self.viewUI]) {
        self.viewUI.frame = CGRectMake(8, 8, self.scrMain.frame.size.width - 16, self.viewUI.frame.size.height - self.heightViewMaXacThuc.constant);
        self.viewUI.layer.cornerRadius = 8.0;
        [self.scrMain addSubview:self.viewUI];
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        self.heightViewMaXacThuc.constant = 0.0;
        [self.viewMaXacThuc setHidden:YES];
        [self.scrMain setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, self.viewUI.frame.size.height)];
    }
}

- (IBAction)suKienChonSMS:(id)sender {
    if (self.heightViewMaXacThuc.constant > 0) {
        CGRect frame = self.viewUI.frame;
        self.heightViewXacThuc.constant -= self.heightViewMaXacThuc.constant;
        frame.size.height -= self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
        self.heightViewMaXacThuc.constant = 0;
    }
    [self.viewMaXacThuc setHidden:YES];
}

- (IBAction)suKienChonToken:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Mật khẩu token"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonMKPI:(id)sender {
    if (self.heightViewMaXacThuc.constant == 0.0) {
        self.heightViewMaXacThuc.constant = 40.0;
        self.heightViewXacThuc.constant += self.heightViewMaXacThuc.constant;
        CGRect frame = self.viewUI.frame;
        frame.size.height += self.heightViewMaXacThuc.constant;
        self.viewUI.frame = frame;
    }
    [self.tfMaXacThuc setPlaceholder:@"Chữ ký mPKI"];
    [self.viewMaXacThuc setHidden:NO];
}

- (IBAction)suKienChonThucHien:(id)sender {
}

- (void)dealloc {
    [_scrMain release];
    [_viewUI release];
    [_heightViewXacThuc release];
    [_heightViewMaXacThuc release];
    [_btnSMS release];
    [_btnToken release];
    [_btnMKPI release];
    [_viewMaXacThuc release];
    [_tfMaXacThuc release];
    [super dealloc];
}
@end
