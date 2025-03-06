//
//  SHSound.m
//  Nocta
//
//  Created by MachOSX on 8/20/13.
//
//

#import <Audiotoolbox/AudioToolbox.h>

#import "SHSound.h"

@implementation SHSound

+ (void)playSoundEffect:(int)soundNumber
{
    NSString *effect = @"";
    NSString *type = @"";
	
	switch ( soundNumber )
    {
        case 1:
			effect = @"water_drip_001";
			type = @"mp3";
			break;
            
        case 2:
            effect = @"water_drip_002";
            type = @"mp3";
            break;
            
        case 3:
            effect = @"water_drip_003";
            type = @"mp3";
            break;
            
        case 4:
            effect = @"pop_001";
            type = @"aif";
            break;
            
        case 5:
            effect = @"pop_002";
            type = @"aif";
            break;
            
        case 6:
            effect = @"klaxon_001";
            type = @"aif";
            break;
            
        case 7:
            effect = @"pause";
            type = @"aif";
            break;
            
        case 8:
            effect = @"gameover";
            type = @"aif";
            break;
            
        case 9:
            effect = @"tada";
            type = @"mp3";
            break;
            
		default:
			break;
	}
	
    SystemSoundID soundID;
	
    NSString *path = [[NSBundle mainBundle] pathForResource:effect ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
	
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
