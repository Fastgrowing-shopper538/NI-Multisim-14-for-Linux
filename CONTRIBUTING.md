# Contributing to Multisim Linux Installer

First of all, thank you for considering contributing to this project.

This repository aims to make installing **NI Multisim 14.0 on Linux** easier and more reliable across multiple distributions.

Contributions of all kinds are welcome:
- Bug fixes
- Distro compatibility improvements
- Documentation updates
- Code cleanup
- Testing reports
- Feature suggestions

---

# Before Contributing

Please make sure to:

- Read the README
- Test changes before submitting
- Search existing issues before opening a new one
- Keep pull requests focused and minimal

---

# Ways You Can Contribute

## Reporting Bugs

When opening an issue, include:

- Linux distribution and version
- Wine version
- Full terminal output
- What you expected to happen
- What actually happened

Helpful example:

```text
OS: Fedora 42
Wine: wine-10.x
Issue: Installer crashes during setup.exe launch
```

---

## Suggesting Features

Feature requests are welcome.

Examples:
- Better Wayland support
- Additional Wine tweaks
- More distro support
- Portable installation mode
- Better launcher integration

Please explain:
- Why the feature is useful
- How it should work
- Possible implementation ideas

---

## Improving Documentation

Documentation improvements are highly appreciated.

Examples:
- Fixing typos
- Improving installation instructions
- Adding troubleshooting steps
- Adding screenshots or GIFs
- Translating documentation

---

# Development Guidelines

## Code Style

Please keep Bash code:

- Readable
- Well-commented
- POSIX-friendly when possible
- Consistently indented

Example:

```bash
if [[ "$DISTRO_FAMILY" == "arch" ]]; then
  echo "Installing Wine..."
fi
```

---

## Testing

Before submitting changes:

- Test on a clean system if possible
- Verify Wine installation works
- Verify Multisim launches correctly
- Check desktop shortcuts

Recommended test environments:
- Ubuntu
- Arch Linux
- Fedora
- openSUSE

---

# Pull Request Process

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Commit clearly
5. Push your branch
6. Open a Pull Request

---

# Commit Message Guidelines

Use meaningful commit messages.

Good examples:

```text
Fix Fedora Wine dependency installation
Add openSUSE launcher support
Improve cleanup routine
```

Avoid:

```text
fix stuff
update
changes
```

---

# Branch Naming

Recommended branch naming:

```text
feature/add-fedora-support
fix/desktop-launcher
docs/update-readme
```

---

# Security Issues

If you discover a security-related issue:

- Do NOT publish exploits publicly immediately
- Open a private discussion first if possible

---

# Community Guidelines

Please be respectful and constructive.

We want this project to be welcoming to:
- Linux users
- students
- electronics enthusiasts
- contributors of all experience levels

Toxic or hostile behavior will not be tolerated.

---

# Project Goals

The main goals of this project are:

- Reliable Multisim installation on Linux
- Cross-distro compatibility
- Minimal manual setup
- Beginner-friendly usage
- Open collaboration

---

# Questions?

If you have questions:
- Open an issue
- Start a discussion
- Submit a draft pull request

---

# Thank You

Your contributions help improve Linux support for electronics students and engineers everywhere.
