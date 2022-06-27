//
//  LoginViewController.m
//  Instagram
//
//  Created by Adam Issah on 6/27/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "FeedViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property bool *emptyField;

@end

@implementation LoginViewController
- (IBAction)didTapSignup:(id)sender {
    [self registerUser];
}
- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.username.text;
//    newUser.email = self.emailField.text;
    newUser.password = self.password.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
        }
    }];
}

- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil && !self.emptyField) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            SceneDelegate *sceneDelegate = (SceneDelegate *)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FeedViewController *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
            sceneDelegate.window.rootViewController = feedViewController;

            
        }
    }];
}
@end
