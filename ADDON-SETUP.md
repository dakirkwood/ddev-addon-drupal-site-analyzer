# DDEV Addon Setup Guide

This guide explains how to publish and use the DDEV Drupal Site Analyzer addon.

## Publishing the Addon

### 1. Create a GitHub Repository

Create a new repository named `ddev-addon-drupal-site-analyzer` in your organization:

```bash
# Example repository structure
your-org/ddev-addon-drupal-site-analyzer/
├── README.md
├── LICENSE
├── install.yaml
├── .gitignore
├── commands/
│   └── web/
│       └── drupal-site-analyzer
├── web-build/
│   └── Dockerfile.drupal-site-analyzer
└── tests/
    ├── test.bats
    └── run-tests.sh
```

### 2. Push the Addon Code

```bash
cd ddev-addon-drupal-site-analyzer
git init
git add .
git commit -m "Initial commit of DDEV Drupal Site Analyzer addon"
git remote add origin https://github.com/your-org/ddev-addon-drupal-site-analyzer.git
git push -u origin main
```

### 3. Create a Release

Create a GitHub release for version v1.0.0:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

## Installing the Addon

### From GitHub (Recommended for Production)

```bash
# Install from your organization's repository
ddev get your-org/ddev-addon-drupal-site-analyzer

# Or from a specific release
ddev get your-org/ddev-addon-drupal-site-analyzer@v1.0.0
```

### From Local Directory (For Development)

```bash
# During development, install from local directory
ddev get /path/to/ddev-addon-drupal-site-analyzer

# Or relative path
ddev get ../ddev-addon-drupal-site-analyzer
```

## Using the Addon

Once installed, the `drupal-site-analyzer` command is available:

```bash
# Basic usage
ddev drupal-site-analyzer

# With options
ddev drupal-site-analyzer --entity-type node --format json

# Save output
ddev drupal-site-analyzer --output site-fields.json
```

## Updating the Addon

### For Users

To update to a newer version:

```bash
# Get the latest version
ddev get your-org/ddev-addon-drupal-site-analyzer

# Or specific version
ddev get your-org/ddev-addon-drupal-site-analyzer@v1.1.0

# Restart DDEV
ddev restart
```

### For Developers

To update the embedded script:

1. Edit the script content in `web-build/Dockerfile.drupal-site-analyzer`
2. Update the version number in the script
3. Update README.md with new features
4. Commit and tag a new release

## Company-Wide Deployment

### Option 1: Documentation Approach

Add to your company's DDEV setup documentation:

```markdown
## Required DDEV Addons

All projects must install these addons:

1. Drupal Site Analyzer
   ```bash
   ddev get your-org/ddev-addon-drupal-site-analyzer
   ```
```

### Option 2: Custom DDEV Config

Create a company-specific DDEV configuration that includes the addon:

```yaml
# .ddev/config.yaml
hooks:
  post-start:
    - exec: |
        if ! command -v drupal-site-analyzer &> /dev/null; then
          echo "Installing required addons..."
          ddev get your-org/ddev-addon-drupal-site-analyzer
        fi
```

### Option 3: Global Installation

For developers who want it available in all projects:

```bash
# Install globally (in ~/.ddev)
mkdir -p ~/.ddev/commands/web
cp ddev-addon-drupal-site-analyzer/commands/web/drupal-site-analyzer ~/.ddev/commands/web/

# Note: This approach requires manual updates
```

## Maintenance

### Testing Changes

Before releasing updates:

```bash
cd ddev-addon-drupal-site-analyzer/tests
./run-tests.sh
```

### Version Management

Follow semantic versioning:
- **Patch** (1.0.1): Bug fixes
- **Minor** (1.1.0): New features, backward compatible
- **Major** (2.0.0): Breaking changes

## Troubleshooting

### Addon Not Installing

```bash
# Check DDEV version (requires 1.21.0+)
ddev version

# Try verbose mode
ddev get your-org/ddev-addon-drupal-site-analyzer -v
```

### Command Not Found

```bash
# Restart DDEV after installation
ddev restart

# Check if command exists
ddev exec which drupal-site-analyzer
```

### Permission Issues

The addon installs files with proper permissions automatically. If issues occur:

```bash
# Reinstall the addon
ddev get your-org/ddev-addon-drupal-site-analyzer --force
```

## Best Practices

1. **Version Control**: Always tag releases properly
2. **Documentation**: Keep README updated with examples
3. **Testing**: Run tests before releasing
4. **Compatibility**: Test with multiple DDEV versions
5. **Support**: Provide clear issue templates

## Support

- Create issues in the addon repository
- Include DDEV version and error messages
- Provide minimal reproduction steps