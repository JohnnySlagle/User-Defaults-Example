//
//  JSTableViewController.m
//  UserDefaultsExample
//
//  Created by Johnny on 11/1/12.
//  Copyright (c) 2012 Johnny Slagle. All rights reserved.
//

#import "JSTableViewController.h"

#import "JSPerson.h"

#pragma mark - Key for Persons Array
static NSString *JSPersonsArrayKey = @"personsArray";

#pragma mark - Class Extension
@interface JSTableViewController ()

/*
 *  This is the array that stores all the currently displayed JSPerson
 */
@property (nonatomic, strong) NSMutableArray *persons;

/*
 *  This is the array of methods that are loaded from the plist.
 */
@property (nonatomic, strong) NSArray *names;

@end

@implementation JSTableViewController

#pragma mark - Init Methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

#pragma mark - View Lifecycle & Memory Warning
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    self.title = @"Random Persons";
    
    // Load Random Names
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"plist"];
    self.names = [NSArray arrayWithContentsOfFile:path];
    
    // Add Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.persons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    JSPerson *cellPerson = [self.persons objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellPerson.name;
    cell.detailTextLabel.text = cellPerson.number;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Selectors
- (void)addPerson {
    // Randomly select a name and generate a Number
    NSString *randomName = [self.names objectAtIndex:arc4random()%[self.names count]];
    NSString *randomNumber = [self randomPhoneNumber];
    
    // Create a new random person & add it to the dataSource
    JSPerson *randomPerson = [[JSPerson alloc] initWithName:randomName andNumber:randomNumber];
    [self.persons addObject:randomPerson];

    // Sort the persons array by name
    NSArray *sortedArray;
    sortedArray = [self.persons sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(JSPerson*)a name];
        NSString *second = [(JSPerson*)b name];
        return [first compare:second];
    }];

    // Set as global dataSource
    self.persons = [sortedArray mutableCopy];
    
    // Reload the tableView's section
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Now save persons to NSUserDefaults
    [self savePersons];
}

#pragma mark - Random Methods
- (NSString *) randomPhoneNumber {
    NSString *randomNumber = @"1 (";
    
    // Do Area Code
    for (int j = 0; j < 3; j++) {
        randomNumber = [randomNumber stringByAppendingString:[NSString stringWithFormat:@"%d",(arc4random() % 10)]];
    }
    randomNumber = [randomNumber stringByAppendingString:@") "];
    
    // Next Three Numbers
    for (int j = 0; j < 3; j++) {
        randomNumber = [randomNumber stringByAppendingString:[NSString stringWithFormat:@"%d",(arc4random() % 10)]];
    }
    randomNumber = [randomNumber stringByAppendingString:@"-"];
    
    // Next Four Numbers
    for (int j = 0; j < 4; j++) {
        randomNumber = [randomNumber stringByAppendingString:[NSString stringWithFormat:@"%d",(arc4random() % 10)]];
    }
    
    return randomNumber;
}

#pragma mark - Loading and Saving Methods
- (void) savePersons {
    // Save the persons array
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.persons]
                                              forKey:JSPersonsArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Lazy Instantiation
- (NSMutableArray *)persons {
    if(_persons == nil) {
        // Load the NSData back from the NSUserDefaults
        NSData *dataRepresentingSavedArray = [[NSUserDefaults standardUserDefaults] objectForKey:JSPersonsArrayKey];
        
        // Is there data there?
        if (dataRepresentingSavedArray != nil) {
            
            // Unarchive the NSData into an array.  This uses JSPerson's initWithCoder method to do so.
            NSMutableArray *oldPersonsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            
            // Store as persons array if an array is unarchived
            if (oldPersonsArray != nil) {
                _persons = [[NSMutableArray alloc] initWithArray:oldPersonsArray];
            }
        } else {
            // Create an empty persons array
            _persons = [[NSMutableArray alloc] init];
        }
    }
    return _persons;
}

@end
