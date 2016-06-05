//
//  MineViewController.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/1.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "MineViewController.h"
#import "UIButton+WebCache.h"

@interface MineViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo {
    
    [[DataManager inst] getUserInfo:nil successCb:^(NSDictionary *responseData) {
        NSString *avatar = [NSString stringWithFormat:@"%@/uploads/avatar/%@",HostIp,responseData[@"avatar"]];
        [_avatar sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal];
        _nickname.text = [NSString stringWithFormat:@"%@",responseData[@"nickname"]];
        _username.text = [NSString stringWithFormat:@"用户名:%@",responseData[@"username"]];
    }];
}

- (IBAction)avatarAction:(UIButton *)sender {
    
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
    [_avatar setImage:image forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [[DataManager inst] uploadAvatar:imageData];//上传头像
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
   
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 1://修改密码
                {
                    [self performSegueWithIdentifier:@"changePasswdVC" sender:self];
                }
                    break;
                case 2://退出登陆
                {
                    [[DataManager inst] logOut:nil successCb:^{
                        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
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
