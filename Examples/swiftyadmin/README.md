# SwiftyAdmin 🚀

An example command line utility to interact with and control a server using TootSDK.

```shell
swift build && ./.build/debug/swiftyadmin get-instance -u https://the-url-of-your-server
```

Since most commands require authentication, you can first login to obtain an access token. The login command demonstrates obtaining a token without a user interface (using the command line).

```shell
swift build && ./.build/debug/swiftyadmin login -u https://the-url-of-your-server
```

## Available commands

To view the current list of commands, build the project and run the program using the `-h` option:

```
swift build && ./.build/debug/swiftyadmin -h
```

### Domain blocks

These commands require the admin:read:domain_blocks or admin:write:domain_blocks authorization scope.
For more information, check out the [docs](https://docs.joinmastodon.org/methods/admin/domain_blocks/).

`list-domain-blocks`

```
USAGE: swiftyadmin list-domain-blocks -u <u> -t <t>

OPTIONS:
  -u <u>                  URL to the instance to connect to
  -t <t>                  Access token for an account with sufficient permissions.
```

`block-domain`

```
USAGE: swiftyadmin block-domain -u <u> -t <t> -d <d>

OPTIONS:
  -u <u>                  URL to the instance to connect to
  -t <t>                  Access token for an account with sufficient permissions.
  -d <d>                  The domain to be blocked
```

`unblock-domain`

```
USAGE: swiftyadmin unblock-domain -u <u> -t <t> -d <d>

OPTIONS:
  -u <u>                  URL to the instance to connect to
  -t <t>                  Access token for an account with sufficient permissions.
  -d <d>                  The domain to be unblocked
```

## Local development

To test it out, you could run:

```shell
swift build && ./.build/debug/swiftyadmin list-domain-blocks -u "..." -t "..."
```
