# SSH User Setup

A simple bash script to create users and generate SSH keys for them. This script handles both creating new users and adding SSH keys to existing users.

## Installation

### Quick Install (as root)

```bash
# Using curl
curl -sSL https://raw.githubusercontent.com/TheHouseWithTheBackdoor/Gadd/refs/heads/main/Gadd.sh -o /usr/local/bin/Gadd.sh && chmod +x /usr/local/bin/Gadd.sh

# Using wget
wget -q https://raw.githubusercontent.com/TheHouseWithTheBackdoor/Gadd/refs/heads/main/Gadd.sh -O /usr/local/bin/Gadd.sh && chmod +x /usr/local/bin/Gadd.sh
```

## Usage

Run the script as root:

```bash
sudo Gadd.sh [options] USERNAME
```

### Options

- `-N`: Create a network-only user with no shell access (only for new users)
- `-h` or `--help`: Display help information

### Examples

```bash
# Create a regular user
sudo useradd.sh johndoe

# Create a network-only user (no shell access)
sudo useradd.sh -N ftpuser

# Add SSH key to an existing user without modifying their account
sudo useradd.sh existinguser

# Show help
sudo useradd.sh --help
```
## Features

- Create a new user account with bash shell
- Create a new network-only user with no shell access (using `-N` flag)
- Generate SSH key pair for any user (new or existing)
- Automatically add public key to authorized_keys
- Proper permission handling
- Special handling for the root user
  
## How It Works

1. If a new user is created:
   - Regular user: Gets a full bash shell
   - Network-only user: Gets no login shell (uses `/usr/sbin/nologin`)

2. For all users (new or existing):
   - Creates an `.ssh` directory in their home directory
   - Generates an Ed25519 SSH key pair
   - Adds the public key to `authorized_keys`
   - Sets proper permissions

## Directory Structure

After running the script for a user, the following files will be created:

```
/home/username/           # User's home directory (or /root for root user)
└── .ssh/                 # SSH directory
    ├── id_ed25519        # Private key
    ├── id_ed25519.pub    # Public key
    └── authorized_keys   # Authorized keys file
```

## Security Notes

- The script creates keys without a passphrase for automation purposes
- For better security, consider adding a passphrase to the key manually
- The script sets proper permissions (700 for .ssh dir, 600 for private key)

## License

[MIT License](LICENSE) - feel free to use and modify as needed.
