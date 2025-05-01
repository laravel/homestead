#!/usr/bin/env bash

if [ ! -f "/etc/apt/apt.conf.d/99allow-repository-change" ]; then
    echo "Configuring APT to allow repository label and other metadata changes..."
    
    cat << EOF | sudo tee /etc/apt/apt.conf.d/99allow-repository-change
Acquire::AllowReleaseInfoChange::Label "true";
Acquire::AllowReleaseInfoChange::Suite "true";
Acquire::AllowReleaseInfoChange::Version "true";
Acquire::AllowReleaseInfoChange::Codename "true";
EOF

    echo "APT configuration for repository changes completed."
else
    echo "APT already configured to handle repository changes."
fi 
