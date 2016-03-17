## Changelog

### Version 0.4.1

 - Adds `signWithMD5:error:` and `verifySignatureWithMD5:message:` to `MIHRSAPrivateKey` and `MIHRSAPublicKey`.
 - Fixes a rare memory leak in `MIHAESKey` and `MIHDESKey` which occurs when OpenSSL failed during encryption or decryption of the data.

There are no API breaks in release 0.4.1 compared to 0.4.

### Version 0.4

 - Renamed `MIHBigInteger#initWithData:` (using `BN_mpi2bn` internally) to `MIHBigInteger#initWithMpiData:` and added a `MIHBigInteger#initWithData:` method which really accepts binary data (using `BN_bin2bn` internally).
 - `RSA_PKCS1_OAEP_PADDING` is now the default padding for RSA since it is more common. (Before it was `RSA_PKCS1_PADDING`).
 - Added the ability to encrypt with private keys and decrypt with public keys.

**Attention: Release 0.4 contains breaking changes.**

### Version 0.3

 - Adds support for handling OpenSSLs `BIGNUM`. (See `MIHBigNumber`.)
 - Adds `signWithSHA128:error:` and `verifySignatureWithSHA128:message:` to MIHRSAPrivateKey and MIHRSAPublicKey.

There are no API breaks in release 0.3.
