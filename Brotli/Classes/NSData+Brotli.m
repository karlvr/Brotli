//
//  NSData+Brotli.m
//  Brotli
//
//  Created by Karl von Randow on 30/03/18.
//

#import "NSData+Brotli.h"

#import <brotli/decode.h>
#import <brotli/encode.h>

@implementation NSData (Brotli)

- (NSData *)brotliCompressed {
    return [self brotliCompressedWithQuality:BROTLI_DEFAULT_QUALITY];
}

- (NSData *)brotliCompressedWithQuality:(int)quality {
    const size_t maxCompressedSize = BrotliEncoderMaxCompressedSize(self.length);
    uint8_t* compressedBuffer = (uint8_t*) malloc(maxCompressedSize * sizeof(uint8_t));

    size_t compressedSize = maxCompressedSize;

    if (!BrotliEncoderCompress(quality,
                               BROTLI_DEFAULT_WINDOW,
                               BROTLI_MODE_GENERIC,
                               (size_t) self.length,
                               (uint8_t *) self.bytes,
                               &compressedSize,
                               compressedBuffer)) {
        return nil;
    }

    /* Make a decision about whether to reuse our existing buffer without copying the data, or
       to make a new buffer.
     */
    if (compressedSize < maxCompressedSize * 0.8 && maxCompressedSize > 8192) {
        /* If the result is less than 80% of the buffer, and the buffer is bigger than 8KB,
           then let's copy and free that extra space as the wasted space is > 1.6 KB.
           Arbitrary numbers.
         */
        NSData *result = [NSData dataWithBytes:compressedBuffer length:compressedSize];
        free(compressedBuffer);
        return result;
    } else {
        return [NSData dataWithBytesNoCopy:compressedBuffer length:compressedSize freeWhenDone:YES];
    }
}

- (NSData *)brotliDecompressed {
    return [self brotliDecompressedAllowPartialInput:NO];
}

- (NSData *)brotliDecompressedAllowPartialInput:(BOOL)allowPartialInput {
    size_t available_in = self.length;
    const uint8_t *next_in = self.bytes;

    const int decompressionBufferSize = 8192;
    uint8_t* decompressedBuffer = (uint8_t*) malloc(decompressionBufferSize * sizeof(uint8_t));
    BOOL usedDecompressedBufferInResult = NO;

    NSMutableData *resultData = nil;

    BrotliDecoderState *s = BrotliDecoderCreateInstance(NULL, NULL, NULL);
    BrotliDecoderResult result = BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT;

    size_t total_out = 0;

    /* Loop while the decoder wants more space to output. */
    while (result == BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT) {
        size_t available_out = decompressionBufferSize;
        uint8_t *next_out = decompressedBuffer;

        result = BrotliDecoderDecompressStream(s, &available_in, &next_in, &available_out, &next_out, &total_out);

        const size_t written = decompressionBufferSize - available_out;

        if (result == BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT || result == BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT) {
            /* Partial result, so accumulate in `resultData` */
            if (resultData == nil) {
                resultData = [NSMutableData dataWithBytes:decompressedBuffer length:written];
            } else {
                [resultData appendBytes:decompressedBuffer length:written];
            }
        } else if (result == BROTLI_DECODER_RESULT_SUCCESS) {
            /* Complete result, so either append to existing buffer or create the final result buffer */
            if (resultData) {
                [resultData appendBytes:decompressedBuffer length:written];
            } else {
                resultData = (NSMutableData*) [NSData dataWithBytesNoCopy:decompressedBuffer length:total_out freeWhenDone:YES];
                usedDecompressedBufferInResult = YES;
            }
        }
    }

    BrotliDecoderDestroyInstance(s);

    if (!usedDecompressedBufferInResult) {
        free(decompressedBuffer);
    }

    if (result == BROTLI_DECODER_RESULT_SUCCESS) {
        return resultData;
    } else if (result == BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT && allowPartialInput) {
        return resultData;
    } else {
        return nil;
    }
}

@end
