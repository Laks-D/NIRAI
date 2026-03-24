# Nirai (நிறை)

## Project Overview
**Nirai** is a high-efficiency service mesh designed to synchronize decentralized street vendors with local demand in real-time. The system is engineered to function under constraints of high energy costs and network instability common in urban micro-markets.

---

## 🛠️ Core Engineering

### 1. Battery-First Tracking
To mitigate GPS-related battery drain, Nirai implements an **Accelerometer-Gated Polling** mechanism.
* **Logic:** The GPS module remains dormant while the device is stationary.
* **Trigger:** The system monitors high-frequency motion data; GPS polling only resumes when a sustained movement threshold is detected.
* **Benefit:** Significant reduction in idle power consumption for vendors stationary for long periods.

### 2. Network Efficiency: H3 Spatial Indexing
Nirai uses **Uber’s H3 Indexing** (Resolution 7) to optimize geospatial data transmission.
* **Index Resolution:** 7 (Approx. $1.22 \text{ km}^2$ per cell).
* **Optimization:** Instead of sending raw Latitude/Longitude pairs, coordinates are hashed into 64-bit H3 indexes.
* **Performance:** This allows for $O(1)$ spatial lookups and reduces the coordinate payload size significantly.

### 3. Scalable Backend
The system utilizes an **Event-Driven Architecture** for lightweight signaling.
* **Protocol:** WebSockets/MQTT for real-time updates.
* **Spatial Filtering:** The backend only broadcasts vendor updates to users within relevant H3 cells, minimizing unnecessary network traffic.

---

## 🎨 Design Philosophy: "Old Money" UI
The user experience follows a **Quiet Luxury** aesthetic to provide a grounded and premium feel for a traditional marketplace.

### Visual Constraints
| Element | Specification |
| :--- | :--- |
| **Typography** | Serif-first (e.g., Playfair Display) for headers to evoke trust. |
| **Palette** | Muted, earth-toned colors (Slate, Charcoal, Champagne). |
| **Spacing** | Generous whitespace and elegant kerning to avoid visual clutter. |

---

## 🚀 Setup & Build

### Prerequisites
* **Flutter SDK:** For the mobile interface.
* **C++ Compiler:** For high-performance spatial processing modules.
* **Docker:** For local backend signaling orchestration.

### Installation
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-org/nirai.git](https://github.com/your-org/nirai.git)
   cd nirai
