//
//  ComposeViewController.m
//  Instagram
//
//  Created by Adam Issah on 6/27/22.
//

#import "ComposeViewController.h"
#import "SceneDelegate.h"
#import "FeedViewController.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITextField *caption;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *share;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) UIImage *imageToPost;

@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
//    imagePickerVC.delegate = self;
//    imagePickerVC.allowsEditing = YES;
//
//    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else {
//        NSLog(@"Camera 🚫 available so we will use photo library instead");
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//
//    [self presentViewController:imagePickerVC animated:YES completion:nil];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapShare:(id)sender {
    [Post postUserImage:self.imageToPost withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"%@", @"Successfully posted Image");
        [self goToFeed];
    }];

}
- (IBAction)didTapCamera:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}
- (IBAction)didTapSelect:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (IBAction)didTapCancel:(id)sender {
    [self goToFeed];
}

- (void) goToFeed {
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FeedViewController *tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
    sceneDelegate.window.rootViewController = tabViewController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
//    CGSize *newSize = (200, 150);
    // Do something with the images (based on your use case)
//    [self resizeImage:originalImage withSize: *newSize];
    [self.photo setImage:editedImage];
    self.imageToPost = editedImage;
   
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
