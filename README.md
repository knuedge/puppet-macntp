# macntp

This was forked from the [managedmac module](https://github.com/dayglojesus/managedmac).
We will be maintaining the ntp portion in this module.

## Getting Started
This module works best with hiera. Simply include the macntp class
```
include macntp
```

Then specify the time servers in hiera
```
macntp::servers:
 - time.apple.com
 - time.google.com
```
