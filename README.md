# Ring Origami Grasping

MATLAB/COCO programs and Abaqus input files accompanying **“Asymmetry-programmed ring origami for direction-selective deformation pathways and multimodal grasping.”** The programs calculate and visualize ring responses under pure-bending and compression-bending loading.

## Package contents

| Folder | Main script and contents |
| --- | --- |
| `Pure-bending/` | `Ellipse_M_P1_ringcoco_c.m`; pure-bending calculations, Abaqus `.inp` files, saved COCO solutions in `data/`, and extracted response `.mat` files. |
| `Compression-bending/` | `Ellipse_r_M_P1_ringcoco_c.m`; sequential compression and bending calculations, Abaqus `.inp` files, and saved COCO solutions in `data/`. Files containing `DYN` use implicit dynamic analysis. |
| `coco/`, `slanCL/`, `slanCM/` | Bundled continuation and color utilities; local copies are also included in the analysis folders. |

Each analysis folder also contains governing equations, boundary conditions, plotting functions, and a `readme.txt` with case-specific instructions.

## System requirements

- **Operating system:** Microsoft Windows 10 Pro (64-bit).
- **MATLAB:** R2024a, with Symbolic Math Toolbox (`ellipticE`). Three-dimensional ribbon rendering also requires `quat2rotm`, available in Robotics System Toolbox (R2024a).
- **Abaqus:** Abaqus/CAE 2023 for the supplied finite element input files.
- **Bundled dependencies:** COCO (`coll_v1` and `bvp_v1` recipes), `slanCL`, `slanCM`, and accompanying color utilities. Use the supplied copies.
- **Tested environment:** MATLAB R2024a and Abaqus 2023 on Windows 10 Pro.
- **Hardware:** No non-standard hardware is required.

## Installation

1. Install MATLAB and the required toolboxes using the [MathWorks installation instructions](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html). Install Abaqus 2023 from [Dassault Systemes](https://www.3ds.com/support/software-downloads) following its installer instructions. Valid software licenses are required.
2. Extract the complete code package. In MATLAB, set the current folder to `Pure-bending` or `Compression-bending`. The main scripts add the local COCO and palette paths. Before running postprocessing sections alone, initialize the paths with:

   ```matlab
   addpath(genpath(fullfile(pwd, 'coco')));
   addpath(genpath(fullfile(pwd, 'slanCL')));
   addpath(genpath(fullfile(pwd, 'slanCM')));
   coco_use_recipes_toolbox coll_v1 bvp_v1
   ```

**Expected package setup time:** under 10 minutes on a normal desktop computer once MATLAB, its required toolboxes, and Abaqus are installed. Downloading, installing, and activating these commercial products takes additional time.

## Demo

The supplied `data/` folders contain saved COCO branches and solutions. To reuse these results, skip the solver section and run the desired postprocessing sections with **Run Section** in MATLAB.

| Demo | Main script | Supplied representative case |
| --- | --- | --- |
| Pure bending | `Pure-bending/Ellipse_M_P1_ringcoco_c.m` | `idx = 3; i = 3; c = 0.8;` (`h/t = 6`, intrinsic twist = 60 degrees). |
| Compression-bending | `Compression-bending/Ellipse_r_M_P1_ringcoco_c.m` | `idx = 2; i = 3; c = 0.8;` (`h/t = 4`, intrinsic twist = 60 degrees). |

For detailed plotting instructions, see `readme.txt` in each analysis folder.

**Expected outputs:** moment-angle and grasping-end displacement-angle curves, ring configurations, three-dimensional renderings, and extracted `*_response.mat` and `*_y1_angle.mat` files.

**Expected demo runtime:** under 1 minute per example using the supplied saved results. Recomputing continuation branches or running Abaqus simulations takes additional time.

## Instructions for use

- For MATLAB calculations, adjust the ring parameters in the main script, then run the solver and postprocessing sections.
- For finite element simulations, import the desired `.inp` file into Abaqus/CAE and submit the job.
- For detailed parameter and plotting settings, see `readme.txt` in each analysis folder.

## COCO and licensing

COCO was developed by its original authors, not by the manuscript authors. [Official COCO downloads](https://sourceforge.net/projects/cocotools/files/releases/) are available online; the required recipes are bundled here.

**Author-written code:** USTC.

Third-party components retain their original licenses; see the [COCO project](https://sourceforge.net/projects/cocotools/), [slanCL](https://www.mathworks.com/matlabcentral/fileexchange/126969-2000-palettes), [slanCM](https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormaps), and license notices in the supplied files. MATLAB and Abaqus require their respective commercial licenses.

## Description in the manuscript

The theoretical model and numerical procedures are described in **Methods, Sections 4.1 and 4.4, and Supplementary Note 1**.
