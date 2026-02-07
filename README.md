# 8bit-samples

Sample code for 6502-based 8-bit computers, primarily for the Atari 8-bit family (400/800/XL/XE).

## Contents

This repository contains code examples in multiple languages and formats:

### Turbo BASIC XL (`tbasic/`)

A collection of **Turbo BASIC XL** programs for Atari 8-bit computers, featuring graphics demonstrations, mathematical visualizations, games, and utility programs.

#### Featured Programs

**Graphics & Visualizations:**

- `MANDEL.TBA` - The Mandelbaum set, an exaple of reddit r/fractals post
- `GR3D.TBA` - 3D surface plot using isometric projection
- `CUBE*.TBA` - Various 3D cube demonstrations (wireframe, double-buffered)
- `SPHERG9.TBA`, `TORUSG9.TBA` - 3D geometric shapes in Graphics 9
- `KLEIN.TBA` - Klein bottle visualization
- `GRADIENT.TBA`, `FIELD.TBA` - Color gradient and field effects
- `MOIRE.TBA`, `WAVE.TBA` - Pattern generation demos
- `POLAR.TBA`, `PARAB.TBA` - Mathematical curve plotting

**Games & Interactive:**

- `LUNAR.TBA`, `LUNAR20.TBA` - Lunar lander animation program
- `BATAROO.TBA` - Bat-themed game wip
- `STARWARS.TBA` - Star Wars music demo
- `DRAW.TBA` - Drawing demo

**Seasonal & Fun:**

- `XMAS.TBA` - Christmas themed
- `VALENTINE.TBA` - Valentine's Day themed
- `NY2025.TBA`, `NY2026.TBA` - New Year celebrations

**ATASCII Art:**

- `atascii/` - Directory containing ATASCII versions for listed basic programs in atari format

**Other Demos:**

- `GTIA.TBA` - GTIA graphics modes demonstration
- `CHARSET.TBA` - Character set manipulation
- `BELLS.TBA` - Sound/music demo

### Assembly (`assembly/`)

6502 assembly language programs using MADS assembler.

### C (`cc65/`)

C programs compiled with the CC65 compiler for 6502 systems.

### FastBasic (`fastbasic/`)

Programs written in FastBasic, a fast BASIC compiler for Atari.

### Other Platforms

- `spectrum/` - ZX Spectrum programs
- `bbc_basic/` - BBC BASIC programs
- `logo/` - Logo language programs
- `ugbasic/` - ugBASIC programs

## Development Tools

### Emulators

- **Atari800** - Cross-platform Atari 8-bit emulator (Linux/Unix)
  - Homepage: <https://atari800.github.io/>
- **Atari800MacX** - macOS version of Atari800 emulator
  - Location: `/Applications/Atari800MacX/Atari800MacX.app/`

### Turbo BASIC XL Tools

- **basicParser** - Turbo BASIC XL parser/compiler
  - Converts `.TBA` (Turbo BASIC source) to tokenized BASIC format
  - Command: `basicParser -b -f -k -o AUTORUN.BAS <source.TBA>`
  - Flags: `-b` (BASIC), `-f` (format), `-k` (keep)

### Disk Image Tools

- **atr** (macOS) - ATR disk image manipulation tool
  - Command: `atr "disk.atr" put -l file.bas AUTORUN.BAS`
- **franny** (Linux) - Alternative ATR tool
  - Command: `franny -A disk.atr -i file.bas -o AUTORUN.BAS`

### Assembly Tools

- **MADS** - Mad Assembler for 6502/65816
- **WUDSN IDE** - Eclipse-based IDE for 6502 development

### Base Disk Images

- `atr_images/TBXL.atr` - Turbo BASIC XL bootable disk image
  - Used as base for creating program disks

## Building & Running

### Turbo BASIC XL Programs

The `tbasic/` directory includes a Makefile for building and running programs:

```bash
cd tbasic
make <program_name>  # Build (without .TBA extension)
make run             # Run in emulator
make clean           # Clean build artifacts
```

**Example:**

```bash
make GR3D    # Creates bin/disk.atr with GR3D as AUTORUN.BAS
make run     # Launches Atari800 with the disk
```

The build process:

1. Copies `TBXL.atr` base image to `bin/disk.atr`
2. Parses the `.TBA` source file to tokenized BASIC
3. Adds the program as `AUTORUN.BAS` to the disk image
4. Runs in the Atari800 emulator

## File Formats

- `.TBA` - Turbo BASIC XL source code (text format)
- `.atr` - Atari disk image format
- `.asm` - 6502 assembly source
- `.c` - C source files for CC65

## Requirements

### For Turbo BASIC XL Development

- Atari800 or Atari800MacX emulator
- basicParser utility
- atr or franny disk image tool

### For Assembly Development

- MADS assembler
- WUDSN IDE (optional, for Eclipse integration)

## Resources

- **Atari 8-bit Documentation**: <https://www.atariarchives.org/>
- **Turbo BASIC XL Manual**: Classic Atari BASIC extension with procedures, enhanced graphics
- **MADS Documentation**: <http://mads.atari8.info/>

## TODO Projects

- Simple graphics macros (modes, line, pixel)
- Player/Missile graphics demo
- Stack manipulation examples
