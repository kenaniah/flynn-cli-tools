# Flynn CLI Tools

Provides a number of CLI tools for managing Flynn clusters using AWS and CloudFlare.

## Installation

Add this line to your application's Gemfile:

```bash
    # Install Flynn (https://flynn.io/docs/cli#installation)
    $ L=/usr/local/bin/flynn && curl -sSL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L

    # Install AWS CLI tools
    $ brew install awscli

    # Install the gem
    $ gem install flynn-cli-tools
```

# Tools Provided

| Tool | Description |
| ---- | ----------- |
| `flynn-cluster` | Administrates flynn clusters on AWS |
| `flynn-dns` | Administrates DNS for a flynn cluster via CloudFlare |
| `flynn-migrate` | Moves a flynn app from one cluster to another |
| `flynn-release` | Creates a new version of an app and tags it in git |
