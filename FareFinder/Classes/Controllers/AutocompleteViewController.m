//
//  AutocompleteViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//
//  Credit goes to:
//  | Alberto Gimeno Brieba
//  | http://iosboilerplate.com/
//  | Autocomplete locations & String Helper
//

#import "AutocompleteViewController.h"
#import "DataSingleton.h"
#import "AFJSONRequestOperation.h"
#import "NSString+Helper.h"

@interface AutocompleteViewController () <UISearchBarDelegate>
  @property DataSingleton *data;
  @property (strong, nonatomic) NSMutableArray *suggestions;
  @property BOOL dirty;
  @property BOOL loading;
  - (void)loadSearchSuggestions;
  - (void)loadDefaultValues;
@end

@implementation AutocompleteViewController

@synthesize data                = _data;
@synthesize delegate            = _delegate;
@synthesize currentSearch       = _currentSearch;
@synthesize suggestions         = _suggestions;
@synthesize dirty               = _dirty;
@synthesize loading             = _loading;
@synthesize selectedSuggestion  = _selectedSuggestion;

#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  // @TODO: Fix the need to have a character entered before the table appears..
  [self loadDefaultValues];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ( [searchText length] > 2 ) {
		if ( _loading ) {
			_dirty = YES;
		}
    else {
			[self loadSearchSuggestions];
    }
	}
  // So if the user deletes text it shows up again.
  else {
    if ( _loading ) {
      _dirty = YES;
    }
    else {
      [self loadDefaultValues];
    }
  }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [_delegate autocompleteViewControllerDidComplete:self];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
}


#pragma mark - Search backend
- (void) loadSearchSuggestions
{
	_loading = YES;
	NSString *query = self.searchDisplayController.searchBar.text;
	NSString *urlEncode = [query urlEncode];
  // Pass in ll and spn for location biased results
  // See https://developers.google.com/maps/documentation/geocoding/v2/?hl=fr#Viewports
  // @TODO: This ain't searhing in our vincinity.. even though the span is the same as the one used for the map
  // view if I entered my address.. so should be in mtl..
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&hl=%@&ll=%f,%f&spn=0.050944,0.017523", urlEncode, [[NSLocale currentLocale] localeIdentifier], _data.currentLocation.coordinate.latitude, _data.currentLocation.coordinate.longitude];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                       JSONRequestOperationWithRequest:request
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                       {
                                         NSMutableArray *sug = [[NSMutableArray alloc] init];

                                         NSArray *placemarks = [JSON objectForKey:@"Placemark"];
                                         
                                         for ( NSDictionary *placemark in placemarks ) {
                                           NSString      *address      = [placemark objectForKey:@"address"];
                                           NSDictionary  *point        = [placemark objectForKey:@"Point"];
                                           NSArray       *coordinates  = [point objectForKey:@"coordinates"];
                                           NSNumber      *lon          = [coordinates objectAtIndex:0];
                                           NSNumber      *lat          = [coordinates objectAtIndex:1];
                                         
                                           MKPointAnnotation *place = [[MKPointAnnotation alloc] init];
                                           place.title = address;
                                           CLLocationCoordinate2D c = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
                                           place.coordinate = c;
                                           [sug addObject:place];
                                         }
                                         
                                         self.suggestions = sug;
                                         
                                         [self.searchDisplayController.searchResultsTableView reloadData];
                                         _loading = NO;
                                         
                                         if ( _dirty ) {
                                           _dirty = NO;
                                           [self loadSearchSuggestions];
                                         }
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                       {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                         _loading = NO;
                                       }];
  [operation start];
}


- (void)loadDefaultValues
{
  _loading = YES;
  
  // Put the current location in the search table
  NSMutableArray *sug = [[NSMutableArray alloc] init];
  [sug addObject:_data.currentLocation];
  self.suggestions = sug;
  
  [self.searchDisplayController.searchResultsTableView reloadData];
  _loading = NO;
  
  if ( _dirty ) {
    _dirty = NO;
    [self loadDefaultValues];
  }
}


#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"suggest";
	
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
	if ( cell == nil )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	}
	
	MKPointAnnotation* suggestion = [_suggestions objectAtIndex:indexPath.row];
	cell.textLabel.text = suggestion.title;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.searchDisplayController setActive:NO animated:YES];
	
	MKPointAnnotation *suggestion = [_suggestions objectAtIndex:indexPath.row];
  // You could add "suggestion" to a map since it implements MKAnnotation
  // example: [map addAnnotation:suggestion]
  
  // Save the suggestion that was pressed.
  _selectedSuggestion = suggestion;
  
  // Tell our delegate we are done.
  [_delegate autocompleteViewControllerDidComplete:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_suggestions count];
}



#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _data = [DataSingleton sharedInstance];
  
  _dirty = NO;
  _loading = NO;
  self.title = @"Search a location";
  self.searchDisplayController.searchBar.text = _currentSearch;
  // We use a really small delay so it's like there is none.
  [self.searchDisplayController.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];
}


- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end