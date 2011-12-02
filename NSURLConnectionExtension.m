//
//  NSURLConnectionExtension.m
//  Culture Shock Miami
//
//  Created by Jason Jaskolka on 9/22/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnectionExtension.h"
#include <SystemConfiguration/SCNetworkReachability.h>

@implementation NSURLConnection (NSURLConnectionExtension)

+ (BOOL)available {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "google.com"); // Attempt to ping google.com
	SCNetworkConnectionFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags); // Store reachability flags in the variable, flags.
	
	if(kSCNetworkReachabilityFlagsReachable & flags) {
		// Can be reached using current connection.
		return YES;
	}
	
	if(kSCNetworkReachabilityFlagsConnectionAutomatic & flags) {
		// Can be reached using current connection, but a connection must be established. (Any traffic to the specific node will initiate the connection)
		return YES;
	}
	
	if(kSCNetworkReachabilityFlagsIsWWAN & flags) {
		// Can be reached via the carrier network
		return YES;
	} else if (kSCNetworkReachabilityFlagsReachable & flags) {
		// Cannot be reached using the carrier network, but it can be reached. (Therefore the device is using wifi)
		return YES;
	} else {
		// Cannot be reached using the carrier network
		return NO;
	}
}

@end
