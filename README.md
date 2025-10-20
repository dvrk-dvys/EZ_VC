# EZ_RVC (WIP)
Real-time voice conversion using So-VITS-SVC

![Voice Conversion Demo](./app/images/little_mermaid_voice.gif)

## Overview
EZ_RVC is a streamlined voice conversion system that allows you to transform your voice into different speakers while maintaining natural speech patterns and emotional expression.

## Setup

### HuggingFace Authentication
1. Visit https://hf.co/pyannote/speaker-diarization-3.1
2. Accept the user conditions for the gated model
3. Get your HuggingFace token from https://hf.co/settings/tokens

**Option 1: CLI Login (Recommended)**
```bash
hf auth login
```
Enter your token when prompted.

**Option 2: Environment Variable**
```bash
export HUGGINGFACE_HUB_TOKEN=your_token_here
```

**Option 3: .env File**
Add your token to the `.env` file:
```
huggingface_token=your_token_here
```

tools:
https://www.audacityteam.org/
