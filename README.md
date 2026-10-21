# Ring Origami Grasping

MATLAB/COCO programs accompanying **“Asymmetry-programmed ring origami for direction-selective deformation pathways and multimodal grasping.”** The programs calculate and visualize ring responses under pure-bending and compression-bending loading.

## System requirements

- **Operating system:** Microsoft Windows 10 Pro (64-bit).
- **MATLAB:** R2024a.
- **Dependencies:** [COCO](https://sourceforge.net/projects/cocotools/files/releases/), [slanCL](https://www.mathworks.com/matlabcentral/fileexchange/126969-2000-palettes), [slanCM](https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormaps), and accompanying color utilities. The links lead to the original download pages; copies are included in this repository.
- **Tested environment:** MATLAB R2024a on Windows 10 Pro.
- **Hardware:** No non-standard hardware is required.

## Installation

Download or clone the repository. In MATLAB, set the current folder to `Pure-bending` or `Compression-bending`. The main scripts load COCO and the color utilities automatically. To add the supplied COCO folder to the MATLAB path manually, run:

```matlab
addpath(genpath(fullfile(pwd, 'coco')));
```

**Expected package setup time:** under 10 minutes.

## Demo

The supplied `data/` folders contain saved COCO branches and solutions. To reuse these results, skip the solver section and run the desired postprocessing sections with **Run Section** in MATLAB.

| Demo | Main script |
| --- | --- |
| Pure bending | `Pure-bending/Ellipse_M_P1_ringcoco_c.m` |
| Compression-bending | `Compression-bending/Ellipse_r_M_P1_ringcoco_c.m` |

**Expected outputs:** moment-angle and grasping-end displacement-angle curves, ring configurations, and three-dimensional renderings.

**Expected demo runtime:** under 1 minute per example.

## Instructions for use

See `readme.txt` in the `Pure-bending` and `Compression-bending` folders for detailed instructions.
