//
//  FeedViewController.m
//  Instagram
//
//  Created by Adam Issah on 6/27/22.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@interface FeedViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property NSArray *posts;

@end

@implementation FeedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
//    [user fetchIfNeeded];
//    [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            for (Post *p in posts) {
                NSLog(@"%@", p);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
            NSLog(@"%@", @"No data you show, haha");
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
- (IBAction)didTapPost:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ComposeViewController *composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    sceneDelegate.window.rootViewController = composeViewController;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *thisPost = _posts[indexPath.row];
    [thisPost.author fetchIfNeeded];
//    [thisPost.image fetchIfNeeded];
    cell.username.text = thisPost.author.username;
    cell.caption.text = thisPost.caption;
//    NSString *baseURL = @"https://parsefiles.back4app.com/";
//    NSString *postImageURL = [ baseURL stringByAppendingString: thisPost. ];
//    [cell.image setImageWithURL:[ NSURL URLWithString:postImageURL ]];
//    [cell.image setImage:];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
