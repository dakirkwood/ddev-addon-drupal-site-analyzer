# DDEV Drupal Site Analyzer Addon

A DDEV addon that provides comprehensive Drupal field structure analysis for all fieldable entities (nodes, media, paragraphs, blocks, users, etc.).

## Features

- 🔍 **Comprehensive Analysis**: Extracts fields from all Drupal entity types
- 📊 **Multiple Output Formats**: JSON, CSV, and Markdown
- 🎯 **Smart Filtering**: Filter by entity type, bundle, or required fields
- 🚀 **Easy Installation**: One command to add to any DDEV project
- 📦 **Self-Contained**: No external dependencies needed in your project

## Installation

```bash
# Install the addon (from the published repository)
ddev get your-org/ddev-addon-drupal-site-analyzer

# Or install from a local directory during development
ddev get ./ddev-addon-drupal-site-analyzer

# Restart DDEV to ensure the command is available
ddev restart
```

## Usage

### Basic Usage

```bash
# Generate complete site analysis
ddev drupal-site-analyzer

# Save to file
ddev drupal-site-analyzer --output site-fields.json

# Get help
ddev drupal-site-analyzer --help
```

### Filtering Options

```bash
# Analyze only node entities
ddev drupal-site-analyzer --entity-type node

# Analyze specific content type
ddev drupal-site-analyzer --entity-type node --bundle article

# Get only required fields
ddev drupal-site-analyzer --required-only

# Verbose output for debugging
ddev drupal-site-analyzer --verbose
```

### Output Formats

```bash
# JSON (default) - Best for programmatic use
ddev drupal-site-analyzer --format json

# CSV - For spreadsheets and data analysis
ddev drupal-site-analyzer --format csv > fields.csv

# Markdown - For documentation
ddev drupal-site-analyzer --format markdown > FIELD-DOCUMENTATION.md
```

## Output Structure

The analyzer extracts comprehensive field information:

```json
{
  "site_info": {
    "config_directory": "config/sync",
    "default_theme": "olivero",
    "admin_theme": "claro",
    "extraction_date": "2024-01-29 12:00:00 UTC",
    "breakpoints": {
      "mobile": { "mediaQuery": "(min-width: 0px)", "weight": 0 },
      "desktop": { "mediaQuery": "(min-width: 1024px)", "weight": 1 }
    }
  },
  "bundles": {
    "node:article": {
      "field_count": 5,
      "required_fields": ["title", "field_image"],
      "fields": [
        {
          "field_name": "field_image",
          "label": "Image",
          "required": true,
          "translatable": false,
          "field_type": "image",
          "storage_type": "image",
          "cardinality": 1,
          "storage_settings": {
            "target_type": "file",
            "display_field": false,
            "display_default": false
          },
          "form_widget": "image_image"
        }
      ]
    }
  }
}
```

## Use Cases

### 1. Test Coverage Development
```bash
# Generate data for Behat tests
ddev drupal-site-analyzer --entity-type node --bundle article --format json | \
  jq '.bundles["node:article"]' > article-fields.json

# Use for test generation
cat article-fields.json | your-test-generator
```

### 2. Migration Planning
```bash
# Analyze source site structure
ddev drupal-site-analyzer --output source-fields.json

# Compare with destination
diff source-fields.json destination-fields.json
```

### 3. Documentation Generation
```bash
# Create field reference documentation
ddev drupal-site-analyzer --format markdown > docs/FIELD-REFERENCE.md

# Generate for specific entity type
ddev drupal-site-analyzer --entity-type node --format markdown > docs/CONTENT-FIELDS.md
```

### 4. Quality Assurance
```bash
# Find all required fields
ddev drupal-site-analyzer --required-only --format csv

# Check specific bundle configuration
ddev drupal-site-analyzer --entity-type node --bundle page
```

## Advanced Usage

### Integration with CI/CD

```yaml
# .gitlab-ci.yml or similar
analyze:fields:
  stage: test
  script:
    - ddev start
    - ddev drupal-site-analyzer --output analysis.json
    - ddev drupal-site-analyzer --required-only --format csv > required-fields.csv
  artifacts:
    paths:
      - analysis.json
      - required-fields.csv
```

### Automated Documentation

Create a script to auto-generate documentation:

```bash
#!/bin/bash
# generate-field-docs.sh

echo "# Field Documentation" > FIELDS.md
echo "" >> FIELDS.md
echo "Generated: $(date)" >> FIELDS.md
echo "" >> FIELDS.md

ddev drupal-site-analyzer --format markdown >> FIELDS.md
```

## What Gets Extracted

For each field, the analyzer collects:

1. **field_name**: Machine name of the field
2. **label**: Human-readable label
3. **required**: Whether the field is required
4. **translatable**: Whether the field is translatable
5. **field_type**: Drupal field type (text, image, entity_reference, etc.)
6. **storage_type**: How the field is stored
7. **cardinality**: Number of values allowed (-1 for unlimited)
8. **storage_settings**: Field-specific settings (target bundles, file extensions, etc.)
9. **form_widget**: Widget used in forms (textfield, select, entity_autocomplete, etc.)

Additional information includes:
- URL patterns (from pathauto configuration)
- Theme breakpoints for responsive design
- Entity and bundle summaries

## Troubleshooting

### Command Not Found
```bash
# Ensure addon is installed
ddev get your-org/ddev-addon-drupal-site-analyzer

# Restart DDEV
ddev restart
```

### No Fields Found
- Ensure you're running from the Drupal project root
- Check that configuration is exported (`drush config:export`)
- Verify config directory location in settings.php

### Permission Errors
```bash
# The command runs inside the container as the web user
# File permissions should not be an issue
```

## Development

### Local Development
```bash
# Clone the addon repository
git clone https://github.com/your-org/ddev-addon-drupal-site-analyzer.git
cd your-drupal-project

# Install from local directory
ddev get ../ddev-addon-drupal-site-analyzer

# Make changes to the addon
# Reinstall to test
ddev get ../ddev-addon-drupal-site-analyzer
```

### Running Tests
```bash
cd ddev-addon-drupal-site-analyzer/tests
./run-tests.sh
```

## Version History

- **v1.0.4**: Breakpoints detection and JSON stability fixes
  - Fixed breakpoints file detection for themes in subdirectories (e.g., themes/custom/mytheme)
  - Added proper escaping for breakpoint labels and media queries
  - Improved JSON validity with better error handling for missing values
  - Enhanced weight extraction with numeric validation

- **v1.0.3**: Enhanced error handling
  - Added intelligent error messages for invalid options:
    - Shows available entity types when invalid type is specified
    - Shows available bundles when invalid bundle is specified
    - Validates format option and shows valid formats
    - Requires entity type when using bundle filter

- **v1.0.2**: Bug fix release
  - Fixed JSON parsing errors for complex field storage settings
  - Improved handling of list fields with allowed_values arrays
  - Better error handling for deeply nested YAML structures

- **v1.0.1**: Previous release

- **v1.0.0**: Initial release
  - Comprehensive field extraction
  - Multiple output formats
  - Entity type and bundle filtering
  - Storage settings extraction

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

- Issues: https://github.com/your-org/ddev-addon-drupal-site-analyzer/issues
- Documentation: https://github.com/your-org/ddev-addon-drupal-site-analyzer/wiki

## Credits

Developed for the Drupal community to simplify field analysis and documentation.