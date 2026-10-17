COMPRESSION-BENDING
===================

Main script: Ellipse_r_M_P1_ringcoco_c.m

Files with DYN in their names are Abaqus simulation input files using implicit dynamic analysis steps.

Usage
-----
Set this folder as the MATLAB current folder. Change c = b/a, epsilon
(intrinsic twist, radians), and h2t = h/t to calculate different rings.
The script first performs compression, then restarts from its final saved
state for bending. Keep the parameter selections consistent between the
solver and all postprocessing sections.

Outputs
-------
- Moment-rotation curve: response section, plotflag = 0.
- Centerline configurations: response section, plotflag = 1.
- Three-dimensional ribbon renderings: "Figure: plot ribbon" and following sections.
- y1-angle curve: "Extract y1 versus loading angle" section.
  y1 = sol.x(end,7), the signed gripper-tip out-of-plane displacement.

Ribbon rendering
----------------
The supplied rendering code shows only the intrinsically twisted elliptical
ring with h2t = 4, epsilon = pi/3 (60 degrees), and c = 0.8:
    idx = 2; i = 3; c = 0.8;



Compute or load the matching COCO branch before plotting; label values
are specific to each continuation run.
