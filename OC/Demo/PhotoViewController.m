//
//  PhotoViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionView.h"

@interface PhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) PhotoCollectionView *photoCollectionView;
@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"添加照片" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.photoCollectionView];
    [self getPhoto];
    // Do any additional setup after loading the view.
}

- (PhotoCollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        CGFloat width = floorf((CGRectGetWidth(self.view.bounds)-10*3)/2);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _photoCollectionView = [[PhotoCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _photoCollectionView.alwaysBounceVertical = YES;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _photoCollectionView;
}

- (void)getPhoto {
    
    __weak typeof(self) weakSelf = self;
    [[DataManager inst] getPhoto:nil successCb:^(NSArray *responseData) {
        [weakSelf.photoCollectionView reloadData:responseData];
    }];
}

- (void)rightBarButtonAction {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sheet dismissViewControllerAnimated:YES completion:nil];
            [weakSelf showPicker:UIImagePickerControllerSourceTypeCamera];
        }];
        [sheet addAction:cameraAction];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sheet dismissViewControllerAnimated:YES completion:nil];
            [weakSelf showPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [sheet addAction:photoLibraryAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"相片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sheet dismissViewControllerAnimated:YES completion:nil];
            [weakSelf showPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }];
        [sheet addAction:photoAlbumAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sheet dismissViewControllerAnimated:YES completion:nil];
    }];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.view.backgroundColor = [UIColor orangeColor];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        
    }
    return _picker;
}

- (void)showPicker:(UIImagePickerControllerSourceType)sourcheType {
    
    self.picker.sourceType = sourcheType;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [picker dismissViewControllerAnimated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [[DataManager inst] uploadImage:imageData successCb:^{
        [weakSelf getPhoto];
    }];//上传头像
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

@end
