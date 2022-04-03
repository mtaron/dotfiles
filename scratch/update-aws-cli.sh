#!/usr/bin/env sh
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-upgrade

# Remove any previous install. Don't want multiple Python installs building up.
sudo rm -f /usr/local/bin/aws
sudo rm -f /usr/local/bin/aws_completer
sudo rm -rf /usr/local/aws-cli

# Download the zip file
curl --silent --show-error --output awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

# Download the AWS CLI signature file
curl --silent --show-error --output awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig

# Verify the signature
gpg --verify awscliv2.sig awscliv2.zip

unzip -q awscliv2.zip

sudo ./aws/install

# Cleanup
rm awscliv2.zip awscliv2.sig
rm -r ./aws

# Verify
aws --version
