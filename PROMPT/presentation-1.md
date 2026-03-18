FUTURE ENHANCEMENTS
Personalized Writing Intelligence - Build a user-specific language and style model
that learns vocabulary, phrasing, and stroke patterns over time, enabling AI-
generated text that closely mimics the user’s natural writing style.
Context-Aware Content Generation - Automatically transform handwritten notes
into structured outputs such as blogs, emails, summaries, or documentation based on
detected writing intent—without requiring manual editing on a phone or PC.
AI assisted writing - A separate gesture for to active AI input to resolve written
mistakes, AI content continuation, utilizing AI tools and more AI functionalities.
Semantic understanding with smart organization and cross-device recall,
enabling handwritten content to be semantically tagged, clustered, searchable, and
contextually accessible across devices and applications with optional cloud sync.
FUNCTIONAL ARCHITECTURE:
# Functional Architecture

```mermaid
flowchart LR

%% =========================
%% DATA STREAM WAVEFORMS
%% =========================
subgraph Waveforms["DATA STREAM WAVEFORMS"]
A1["Optical X/Y vs Time  
X(t), Y(t) Amplitude  
(Shows continuous movement)"]

A2["Pressure vs Time  
Pressure(t)  
(Shows contact peaks)"]

A3["Final Writing Signal  
(Literal Pressure Gated)  
XY Coordinates  

Low Pressure → No Write  
High Pressure → Write"]
end

%% =========================
%% PHYSICAL LAYER
%% =========================
subgraph Physical["1. PHYSICAL LAYER (Pen Hardware Unit)"]

S1["Optical Sensor  
PMW3360  
Outputs: Raw (x, y, t)"]

S2["Pressure Sensor  
FSR402  
Outputs: Raw (p, t)"]

BLE["BLE SoC Module  
nRF52832  

Functions:
• Aggregates
• Packetizes
• Streams Raw Data"]

S1 -->|"Raw (x,y,t) data"| BLE
S2 -->|"Raw (p,t) data"| BLE

end

%% =========================
%% TRANSPORT LAYER
%% =========================
subgraph Transport["2. TRANSPORT LAYER"]

T1["Bluetooth Low Energy  
BLE 5.0 Stream  

Characteristics:
• Raw Stroke Data Packets
• Low Power
• Near Real-Time"]

end

BLE --> T1

%% =========================
%% APPLICATION LAYER
%% =========================
subgraph Application["3. APPLICATION LAYER"]

APP1["Data Synchronization  
& Buffering"]

APP2["Time-Based  
Sensor Fusion Engine"]

APP3["Stroke  
Reconstruction Engine"]

APP4["OCR + AI/ML  
Recognition Engine"]

APP5["Text Structuring  
& Formatter  
(.txt / .md)"]

APP6["Storage / Export /  
Cloud Sync"]

APP1 --> APP2
APP2 --> APP3
APP3 --> APP4
APP4 --> APP5
APP5 --> APP6

end

T1 --> APP1

%% =========================
%% REAL TIME PROCESS NOTE
%% =========================
Note1["Real-Time Sampling:

• Sampling of (p,t) pressure data at 100Hz  
• If sampled pressure p(t) > dynamic threshold  
• Accept point (x,y)  
• Only plot points where pressure intersects XY position"]

APP2 --- Note1

%% =========================
%% INTERNAL APPLICATION MODULES
%% =========================
subgraph Internal["5. INTERNAL APPLICATION FUNCTIONAL MODULES"]

M1["BLE Listener & Stability  
Manages pen connection and stability"]

M2["Timestamp Sync  
Latency correction and alignment  
of (x,y,p) data"]

M3["Stroke & Pen-Lift Detection  
Separates writing from lifts"]

M4["Coordinate Normalization  
& Filtering  
Noise and jitter removal"]

M5["Context-Aware Text Processing  
Paragraph detection & formatting"]

M6["Trajectory Reconstruction  
Smooth vector representation  
of strokes"]

M7["Multilingual OCR & AI  
High accuracy conversion  
50+ languages"]

M8["Intelligent Text Post Processing  
Paragraphs, formatting,  
grammar correction"]

M9["Real-Time Export & Sync  
Background export (.txt, .md)  
Cloud status"]

M10["Local Storage & Export  
Disk management & manual exports"]

M11["3rd Party API  
Open API for custom software"]

end

APP1 --- M1
APP1 --- M2
APP2 --- M3
APP2 --- M4
APP3 --- M6
APP4 --- M7
APP5 --- M8
APP6 --- M9
APP6 --- M10
APP6 --- M11
APP5 --- M5

%% =========================
%% ADAPTIVE INTELLIGENCE LAYER
%% =========================
subgraph AI["7. ADAPTIVE INTELLIGENCE LAYER (Future Ready)"]

AI1["Personalization Engine"]

AI2["AI Integrations"]

AI3["Adaptive Recognition Model"]

AI4["Continuous Accuracy Improvement"]

end

APP4 --> AI1
APP4 --> AI2
APP4 --> AI3
APP4 --> AI4

```
----
LIST OF MODULES
Pen Module:
- optical sensor (PMW3360)
- pressure sensor (FSR402)
- SOC (Tiny nRF52832)
Transport Layer:
- Bluetooth
- internal flash memory 5mb (offline capability)
Application Layer:
- Mobile or PC running a software application
Cloud
- Cloud for syncing data between devices
- Serverless database for storing
Software and tools
Pen Module:
- Embedded C collecting sensor data
- Transmission layer logic
Application Layer:
- React-native cross platform mobile application
- Electron cross platform for desktop application
- Core Application login in native languages(Kotlin,C++,Shift)
- Large Language Models for processing mistakes in handwriting
- CNN & RNN (LSTMs/RNNs) ML for ETL pipeline converting handwriting to text
Cloud
- Edge function in cloudflare workers
- Neon S3 compatible content lake for various purposes
