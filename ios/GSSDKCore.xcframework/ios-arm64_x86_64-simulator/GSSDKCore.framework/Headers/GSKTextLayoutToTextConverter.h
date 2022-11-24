// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from sdk-core.djinni

#import "GSKTextLayout.h"
#import "GSKTextLayoutToTextConverterResult.h"
#import <Foundation/Foundation.h>
@class GSKTextLayoutToTextConverter;
@protocol GSKLogger;


/**
 * Converts a text layout to its textual representation
 *
 * The goal is to properly recreate lines, paragraphs etc.
 */
@interface GSKTextLayoutToTextConverter : NSObject

/** Create an text layout to text converter */
+ (nullable GSKTextLayoutToTextConverter *)create:(nullable id<GSKLogger>)logger;

/** Perform the conversion */
- (nonnull GSKTextLayoutToTextConverterResult *)convert:(nonnull GSKTextLayout *)textLayout;

@end
