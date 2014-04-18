//
// Copyright (C) 2014 Michael Hohl <http://www.michaelhohl.net/>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/**
 * Singleton which cares about initalising and configuring the OpenSSL library.
 *
 * @author <a href="http://www.michaelhohl.net/">Michael Hohl</a>
 */
@interface MIHCryptoConfiguration : NSObject

/**
 *  MIHCryptoConfig is a singelton! Don't try to instantiate yourself.
 *
 *  @return The singleton instance of MIHCryptoConfig.
 */
+ (instancetype)defaultConfig;

/**
 *  Loads the basic configuration and config from the passed file.
 *  
 *  It is highly recommented to always call this method on application startup even if you don't pass a
 *  configFilePath since it also loads the default configuration.
 *
 *  @warning This method only calls the OpenSSL own load config method which is only allowed to get called once!
 *
 *  @param configFilePath Path of the config file or nil if you just want to load basic configuration.
 */
- (void)load:(NSString *)configFilePath;

@end
