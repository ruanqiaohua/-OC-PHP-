//
//  PhotoViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionView.h"

@interface PhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) PhotoCollectionView *photoCollectionView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *photos;

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
    self.photoCollectionView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    [self getPhoto];
    // Do any additional setup after loading the view.
}

- (PhotoCollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _photoCollectionView = [[PhotoCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _photoCollectionView.alwaysBounceVertical = YES;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _photoCollectionView.itemDidSelectCb = ^(NSIndexPath *indexPath){
            [weakSelf showPhotoBrowser:indexPath];
        };
        _photoCollectionView.itemEndLongTap = ^(NSIndexPath *indexPath){
            [weakSelf showSheet:indexPath];
        };
    }
    return _photoCollectionView;
}

- (void)showPhotoBrowser:(NSIndexPath *)indexPath {

    if (!_images) return;

    _photos = [NSMutableArray array];
    for (NSString *imageName in _images) {
        NSString *urlString = [NSString stringWithFormat:@"%@/app/uploads/image/%@",HostIp,imageName];
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:urlString]]];
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    [browser setCurrentPhotoIndex:indexPath.item];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    [self showViewController:browser sender:self];
}

- (void)getPhoto {
    
    __weak typeof(self) weakSelf = self;
    [[DataManager inst] getPhoto:nil successCb:^(NSArray *responseData) {
        _images = [NSMutableArray arrayWithArray:responseData];
        [weakSelf.photoCollectionView reloadData:_images];
    }];
}

- (void)rightBarButtonAction {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self.photoCollectionView performBatchUpdates:nil completion:nil];
}


- (void)showSheet:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delectAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sheet dismissViewControllerAnimated:YES completion:nil];
        NSString *imageName = _images[indexPath.item];
        [[DataManager inst] removeImage:@{@"imageName":imageName} successCb:^{
            [weakSelf.images removeObjectAtIndex:indexPath.item];
            [weakSelf.photoCollectionView reloadData:weakSelf.images];
        }];
    }];
    [sheet addAction:delectAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sheet dismissViewControllerAnimated:YES completion:nil];
    }];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];

}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}
@end
