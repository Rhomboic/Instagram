//
//  ProfileViewController.m
//  Instagram
//
//  Created by Adam Issah on 6/28/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "ProfileCell.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *makePost;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    [self fetchPosts];
    self.username.text = [PFUser currentUser].username;
    // Do any additional setup after loading the view.
}

- (void) fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
//    NSLog(@"%@", [PFUser currentUser]);
        query.limit = 20;

        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts != nil) {
                NSLog(@"%lu@",(unsigned long)posts.count);
                self.posts = posts;
                [self.collectionView reloadData];
                NSLog(@"%@", @"🤡🤡🤡🤡");
                NSLog(@"%lu@",(unsigned long)self.posts.count);
            } else {
                NSLog(@"%@", error.localizedDescription);
                
            }
        }];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"%@", @"Logged out User Sunccessfully");
    }];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}
- (IBAction)didTapMakePost:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ComposeViewController *composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    sceneDelegate.window.rootViewController = composeViewController;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;

}

@end
