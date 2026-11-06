# Scriptor surface-agnostic digital pen

Scriptor is a surface-agnostic digital pen system that tracks handwriting on standard paper and converts physical strokes into digital text.

## Overview

The Scriptor digital pen hardware and software pipeline provides an optical motion tracking digitizer for writing on any plain paper or flat surface. Standard smart pens require proprietary dot-pattern paper, external tracking clips, or specialized tablets. Scriptor eliminates specialized paper by tracking coordinate displacement directly at the pen tip with an optical sensor and a force sensor. An onboard microcontroller streams raw motion coordinates and pressure values over Bluetooth Low Energy 5.0 to a host machine. A desktop or mobile application processes the raw data stream, aligns timestamps, reconstructs stroke trajectories, and converts strokes into Markdown and plain text files with at least 90% character recognition accuracy.

This repository holds the project specifications, presentation materials, Anna University academic report guidelines, and the OpenCode multi-agent configuration used to build the engineering documentation.

## Architecture

The system has four core layers.

### Hardware layer

The pen hardware unit collects physical movement and contact signals:
- Optical sensor: PixArt PMW3360 optical tracking sensor outputs relative displacement coordinates (x, y, t).
- Pressure sensor: Interlink FSR402 force-sensing resistor outputs tip contact pressure (p, t).
- Microcontroller: Nordic Semiconductor nRF52832 Bluetooth Low Energy system-on-chip runs Embedded C firmware, samples pressure at 100 Hz, bundles coordinate data, and controls transmission.
- Local storage: 5 MB SPI flash memory stores stroke packets when the pen is disconnected from a host device.

### Transport layer

The transport layer transmits and synchronizes sensor data streams:
- Wireless protocol: Bluetooth Low Energy 5.0 streams raw stroke packets at 2.4 GHz.
- Timestamp alignment: The receiver matches optical coordinates (x, y, t) with pressure readings (p, t) by timestamp.
- Pressure gating: The application discards coordinate updates when measured tip pressure falls below the contact threshold. The system only records strokes when the pen tip touches paper.

### Application and recognition layer

The host client application runs on mobile or desktop operating systems:
- Cross-platform interface: React Native powers mobile devices and Electron powers desktop platforms, using native modules written in C++, Kotlin, and Swift.
- Signal processing: Filters remove jitter, calibrate offsets, and separate written strokes from pen lifts.
- Recognition pipeline: Convolutional neural networks, bidirectional long short-term memory networks with CTC loss, and vision transformers convert raw coordinate trajectories into characters.
- Text formatting: Language models inspect character sequences, correct recognition errors, and output formatted Markdown and plain text files.
- Optional cloud sync: Cloudflare Workers and Neon serverless storage synchronize documents across client devices.

### Workspace documentation layer

This repository configures an automated documentation system:
- OpenCode configuration: `opencode.json` defines tool permissions, token compaction, and workspace agent settings.
- Memory server: A local Model Context Protocol service (`mcp-ai-memory`) connects to PostgreSQL using `Xenova/all-MiniLM-L6-v2` embeddings for vector retrieval.
- Academic guidelines: `AGENTS.md` and `PROMPT/` define Anna University report formatting standards, Mermaid diagram validation rules, and anti-hallucination constraints.

## Setup

### Prerequisites

- Node.js 18 or newer
- Git
- OpenCode CLI
- PostgreSQL 14 or newer (required only when running the local MCP memory server)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/devsanthoshmk/pen-proj.git
   cd pen-proj
   ```

2. Optional: Install the memory service dependency:
   ```bash
   npm install -g mcp-ai-memory
   ```

3. Optional: Set up the PostgreSQL database for the memory server:
   ```bash
   createdb aimemory
   ```

## Usage

### Workspace documentation workflow

Start OpenCode in the project root:
```bash
opencode
```
OpenCode reads `opencode.json` and loads `AGENTS.md`. The default agent `doc_architect` coordinates the documentation workflow, cross-referencing presentation slides in `PROMPT/` to draft report chapters according to university guidelines.

### Pen hardware workflow

1. Turn on the Scriptor digital pen hardware.
2. Pair the nRF52832 module with the host computer or phone over Bluetooth Low Energy.
3. Write on standard paper. The PMW3360 tracks tip displacement and the FSR402 registers contact pressure at 100 Hz.
4. The host application captures the raw data stream, rejects non-contact movement, and converts handwriting to text.
5. Save or export the output as `.txt` or `.md` files.

## Configuration

The workspace behavior is configured in `opencode.json`:
- `default_agent`: Sets `doc_architect` as the default agent for repository tasks.
- `mcp.memory`: Configures the `mcp-ai-memory` tool with database connection parameters, `Xenova/all-MiniLM-L6-v2` embeddings, and log levels.
- `permission`: Sets execution permissions for file edits, bash commands, and web requests.
- `compaction`: Automatically prunes context history when token counts exceed 15,000 tokens.
- `instructions`: Loads `AGENTS.md` as global instructions for all agents.
