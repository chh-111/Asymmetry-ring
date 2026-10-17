# Ring Origami Grasping

MATLAB/COCO programs and Abaqus input files accompanying **“Asymmetry-programmed ring origami for direction-selective deformation pathways and multimodal grasping.”** The programs calculate and visualize ring responses under pure-bending and compression–bending loading.

## File Structure

```text
Code available/
├── README.md, readme.txt                  Overall documentation
├── Pure-bending/
│   ├── readme.txt                        Pure-bending usage and rendering settings
│   ├── Ellipse_M_P1_ringcoco_c.m          Main solver and postprocessing
│   ├── Ellipse_M_P1_ring_c.m              Governing equations
│   ├── Ellipse_M_P1_ring_bc_c.m           Boundary conditions
│   ├── Ellipse_M_P1_ring_bc_DFDX_c.m      Boundary-condition Jacobian
│   ├── coco_get_labs_at_Y.m              Select labels by loading angle
│   ├── plotringBend.m                    Plot complete ring centerlines
│   ├── plotRibbon.m                      Render three-dimensional ring surfaces
│   ├── J_cal.m                          Calculate the torsional constant
│   ├── J.m                              Standalone torsional-constant example
│   ├── linspecer.m                       Line-color utility
│   ├── tab10.m, tab20.m, tab20b.m, tab20c.m  Colormap utilities
│   ├── 20260920-0du-c10-ht6.inp           Abaqus: untwisted circular ring
│   ├── 20260920-60du-c08-ht6.inp          Abaqus: twisted elliptical ring
│   ├── *_response.mat                   Extracted moment-angle data
│   ├── *_y1_angle.mat                   Extracted tip-displacement-angle data
│   ├── data/                            Saved COCO branches and solutions
│   └── coco/, slanCL/, slanCM/           Local dependency copies
├── Compression-bending/
│   ├── readme.txt                        Compression-bending usage and rendering settings
│   ├── Ellipse_r_M_P1_ringcoco_c.m        Main two-stage solver and postprocessing
│   ├── Ellipse_r_M_P1_ring_c.m            Governing equations
│   ├── Ellipse_r_M_P1_ring_bc_c.m         Boundary conditions
│   ├── Ellipse_r_M_P1_ring_bc_DFDX_c.m    Boundary-condition Jacobian
│   ├── coco_get_labs_at_Y_exclude.m      Select labels outside specified segments
│   ├── plotringBend.m                    Plot complete ring centerlines
│   ├── plotRibbon.m                      Render three-dimensional ring surfaces
│   ├── J_cal.m                          Calculate the torsional constant
│   ├── J.m                              Standalone torsional-constant example
│   ├── interpomap.m                      Interpolate marker colors
│   ├── quadratic_interpolation.m         Piecewise quadratic interpolation utility
│   ├── linspecer.m                       Line-color utility
│   ├── tab10.m, tab20.m, tab20b.m, tab20c.m  Colormap utilities
│   ├── 20260927-0du-c10-ht4-Forward.inp   Abaqus: circular ring, forward loading
│   ├── 20260927-60du-c08-ht4-Forward.inp  Abaqus: twisted elliptical ring, forward
│   ├── 20260927-60du-c08-ht4-Reverse.inp  Abaqus: twisted elliptical ring, reverse
│   ├── *DYN*.inp                        Abaqus implicit dynamic simulations
│   ├── h2t4-c08-60du-1.png               Exported configuration rendering
│   ├── data/                            Saved compression and bending solutions
│   └── coco/, slanCL/, slanCM/           Local dependency copies
├── coco/                                Third-party continuation package
├── slanCL/                              Third-party discrete color palettes
└── slanCM/                              Third-party continuous colormaps
```

The main scripts initialize the shared dependencies beside the two analysis folders.

## Usage

Use MATLAB with Symbolic Math Toolbox and a compatible `quat2rotm` function for ribbon rendering. Abaqus 2023 is used for the `.inp` files.

Set the MATLAB current folder to the desired analysis folder. Follow its `readme.txt` to select parameters, run the main script sections, and plot results.

## COCO

COCO is included in this package and was downloaded from its original developers; it was not developed by the manuscript authors. The scripts use `coll_v1` and `bvp_v1` from `coco/coco/`.

Official downloads: <https://sourceforge.net/projects/cocotools/files/releases/>

## License

USTC
