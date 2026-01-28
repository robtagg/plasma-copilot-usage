# Contributing to GitHub Copilot Usage Widget

Thank you for your interest in contributing to the GitHub Copilot Usage Widget! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue on GitHub with the following information:

1. **Clear Title**: Use a descriptive title for the issue
2. **Description**: Provide a clear description of the bug
3. **Steps to Reproduce**: List the steps to reproduce the behavior
4. **Expected Behavior**: Describe what you expected to happen
5. **Actual Behavior**: Describe what actually happened
6. **Environment**:
   - KDE Plasma version
   - Operating system and version
   - GitHub CLI version (`gh --version`)
   - Widget version

### Suggesting Enhancements

Enhancement suggestions are welcome! Please open an issue with:

1. **Clear Title**: Use a descriptive title
2. **Use Case**: Explain why this enhancement would be useful
3. **Proposed Solution**: Describe how you envision the enhancement working
4. **Alternatives**: Mention any alternative solutions you've considered

### Pull Requests

We actively welcome pull requests! Here's how to contribute code:

1. **Fork the Repository**: Create your own fork of the project
2. **Create a Branch**: Create a feature branch from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make Your Changes**: Implement your feature or bug fix
4. **Test Thoroughly**: Ensure your changes work as expected
5. **Commit Your Changes**: Use clear, descriptive commit messages
   ```bash
   git commit -m "Add feature: description of feature"
   ```
6. **Push to Your Fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**: Submit a PR to the main repository

### Pull Request Guidelines

- **Description**: Provide a clear description of what your PR does
- **Related Issues**: Reference any related issues (e.g., "Fixes #123")
- **Testing**: Describe how you tested your changes
- **Screenshots**: Include screenshots for UI changes
- **Keep it Focused**: One feature or fix per PR when possible
- **Code Quality**: Follow the existing code style and conventions

## Development Setup

### Prerequisites

- KDE Plasma 6.0 or later
- Qt 6 development tools
- GitHub CLI (`gh`)
- Text editor or IDE with QML support

### Local Development

1. Clone your fork:
   ```bash
   git clone https://github.com/robtagg/plasma-copilot-usage.git
   cd plasma-copilot-usage
   ```

2. Install the widget locally:
   ```bash
   ./install.sh
   ```

3. For rapid testing during development:
   ```bash
   plasmoidviewer -a com.github.copilot-usage
   ```

4. After making changes, reinstall and restart Plasma Shell:
   ```bash
   ./install.sh
   kquitapp6 plasmashell && kstart plasmashell
   ```

### Project Structure

```
com.github.copilot-usage/
├── contents/
│   ├── config/          # Configuration system
│   │   ├── config.qml   # Config dialog structure
│   │   └── main.xml     # Config schema (KConfig XML)
│   └── ui/              # User interface
│       ├── main.qml     # Main widget UI and logic
│       └── configGeneral.qml  # Configuration page UI
├── metadata.json        # Widget metadata (name, version, etc.)
├── install.sh          # Installation script
└── screenshot.png      # Widget screenshot
```

## Coding Standards

### QML Code Style

- **Indentation**: Use 4 spaces (no tabs)
- **Naming Conventions**:
  - Properties: camelCase (e.g., `refreshInterval`)
  - IDs: camelCase (e.g., `refreshTimer`)
  - Functions: camelCase (e.g., `fetchUsage()`)
- **Organization**: Group related properties together
- **Comments**: Add comments for complex logic

### Example QML Style

```qml
Item {
    id: root

    // Properties
    property int value: 0
    property bool isActive: false

    // Signal handlers
    onValueChanged: {
        console.log("Value changed:", value)
    }

    // Functions
    function updateValue(newValue) {
        value = newValue
    }

    // Child items
    Rectangle {
        anchors.fill: parent
        color: root.isActive ? "green" : "gray"
    }
}
```

## Testing

### Manual Testing Checklist

Before submitting a PR, please verify:

- [ ] Widget installs without errors
- [ ] Widget appears in the "Add Widgets" dialog
- [ ] Widget can be added to the panel
- [ ] Data fetches correctly from GitHub API
- [ ] Tooltip shows correct information
- [ ] Configuration dialog opens and saves settings
- [ ] Manual refresh works (middle-click)
- [ ] Expanded view displays correctly
- [ ] Error states are handled gracefully
- [ ] Widget works after Plasma Shell restart

### Testing Different Scenarios

1. **Authentication Errors**: Test with `gh` not authenticated
2. **Network Errors**: Test with network disconnected
3. **API Changes**: Verify handling of unexpected API responses
4. **Configuration**: Test various refresh intervals
5. **Visual States**: Check different usage levels (high, medium, low)

## Documentation

When adding features or making changes:

- Update the README.md if user-facing functionality changes
- Update configuration documentation for new settings
- Add inline comments for complex code
- Update this CONTRIBUTING.md if development process changes
- Update screenshots if the UI changes significantly

### Updating Screenshots

If you make significant visual changes to the widget:

1. Take a new screenshot of the expanded widget view
2. Update both:
   - `screenshot.png` in the root directory (for GitHub/README)
   - `contents/images/screenshot.png` (for KDE widget preview)
3. Ensure screenshots are clear and show the widget's key features
4. Recommended size: At least 300px wide for clarity

## Release Process

Maintainers follow this process for releases:

1. Update version in `metadata.json`
2. Update CHANGELOG (if maintained)
3. Create a git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`
4. Push the tag: `git push origin v1.0.0`
5. Create a GitHub release with release notes

## Questions?

If you have questions about contributing:

- Open an issue with the "question" label
- Reach out to the maintainer via email (see README.md)

## License

By contributing to this project, you agree that your contributions will be licensed under the GNU General Public License v3.0.

---

Thank you for contributing to the GitHub Copilot Usage Widget!
