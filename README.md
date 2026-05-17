# SPM Physical Design Implementation
## RTL to GDSII using OpenLane2 + Sky130 PDK

## Project Overview
Complete physical design implementation of a 32-bit Serial Parallel Multiplier (SPM) 
using open-source EDA tools. Full flow from RTL to GDSII including timing closure, 
DRC and LVS signoff.

## Design Specifications
| Parameter | Value |
|---|---|
| Design | 32-bit Serial Parallel Multiplier (SPM) |
| Technology | Sky130 (130nm) |
| Tools | OpenLane2, OpenROAD, Yosys, Magic, Netgen |
| Clock Period | 7ns (143 MHz) |
| PDK | Google/SkyWater Sky130A |

## Flow Summary
| Stage | Tool | Status |
|---|---|---|
| Synthesis | Yosys | ✅ Done |
| Floorplanning | OpenROAD | ✅ Done |
| Placement | OpenROAD | ✅ Done |
| CTS | OpenROAD | ✅ Done |
| Routing | OpenROAD | ✅ Done |
| STA | OpenROAD | ✅ Done |
| DRC | Magic | ✅ Clean |
| LVS | Netgen | ✅ Clean |

## Timing Results (MCMM Analysis - 9 Corners)
| Corner | Setup WNS | Hold WNS | Setup Violations | Hold Violations |
|---|---|---|---|---|
| nom_tt_025C_1v80 | +4.71ns | +0.23ns | 0 | 0 |
| nom_ss_100C_1v60 | +3.64ns | +0.42ns | 0 | 0 |
| nom_ff_n40C_1v95 | +5.07ns | +0.05ns | 0 | 0 |
| max_tt_025C_1v80 | +4.67ns | +0.23ns | 0 | 0 |
| max_ss_100C_1v60 | +3.60ns | +0.41ns | 0 | 0 |
| max_ff_n40C_1v95 | +5.05ns | +0.05ns | 0 | 0 |
| min_tt_025C_1v80 | +4.74ns | +0.23ns | 0 | 0 |
| min_ss_100C_1v60 | +3.68ns | +0.43ns | 0 | 0 |
| min_ff_n40C_1v95 | +5.10ns | +0.05ns | 0 | 0 |

## DRC Results
| Check | Result |
|---|---|
| DRC Violations | 0 ✅ |
| LVS Result | Circuits match uniquely ✅ |

## Key Findings & Analysis
### Input Port Fanout Violation Analysis
- **Observation:** rst and y input ports driving 64 cells (limit: 10)
- **Root Cause:** SPM architecture requires rst and y to connect to all 32 
  CSADD instances simultaneously — architectural limitation
- **Attempted Fixes:**
  - RTL buffer insertion using buf primitives
  - SYNTH_MAX_FANOUT constraint set to 10
  - Sky130 explicit buffer cell instantiation
- **Conclusion:** Violations are architectural — require I/O buffer insertion 
  at chip level or RTL pipelining for complete resolution

## Tools Used
- **OpenLane2** — RTL to GDSII flow
- **OpenROAD** — Placement, CTS, Routing, STA
- **Yosys** — Synthesis
- **Magic** — DRC, SPICE extraction
- **Netgen** — LVS
- **Sky130 PDK** — Google/SkyWater 130nm process

## How to Reproduce
1. Open the notebook:
   [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/efabless/openlane2/blob/main/notebook.ipynb)
2. Run Setup Nix and Get OpenLane cells
3. Replace spm.v with the file in this repository
4. Set CLOCK_PERIOD=7 in Config
5. Run all cells
