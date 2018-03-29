//
//  NSData+Brotli.h
//  Brotli
//
//  Created by Karl von Randow on 30/03/18.
//

#include <Foundation/Foundation.h>

@interface NSData (Brotli)

- (nullable NSData *)brotliCompressed;
- (nullable NSData *)brotliCompressedWithQuality:(int)quality;

- (nullable NSData *)brotliDecompressed;
- (nullable NSData *)brotliDecompressedAllowPartialInput:(BOOL)allowPartialInput NS_SWIFT_NAME(brotliDecompressed(allowPartialInput:));

@end
