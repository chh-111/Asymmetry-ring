PURE BENDING
============

Main script: Ellipse_M_P1_ringcoco_c.m

Usage
-----
Set this folder as the MATLAB current folder. Change c = b/a, epsilon
(intrinsic twist, radians), and h2t = h/t to calculate different rings.
In the solver, c is calculated from a and b. epsilon and h2t are selected
through angle_list(i) and h2t_list(idx). Keep the case settings consistent
between the solver and all postprocessing sections.

Outputs
-------
- Moment-rotation curve: response section, plotflag = 0.
- Centerline configurations: response section, plotflag = 1.
- Three-dimensional ribbon renderings: "Figure: plot ribbon" section.
- y1-angle curve: "Extract y1 versus loading angle" section.
  y1 = sol.x(end,7), the signed gripper-tip out-of-plane displacement.

Ribbon rendering
----------------
Edit idx, i, c, and plot_lab_0 in the ribbon section using the values
listed below. The four Fig. 1 cases use h2t = 6:

Ring                              idx   i    c     plot_lab_0
Untwisted circular                 3    1   1.0    [373,549]
60-degree twisted circular         3    3   1.0    [528,856,763]
Untwisted elliptical               3    1   0.8    [428,595]
60-degree twisted elliptical       3    3   0.8    [627,840,925]

For example: idx = 3; i = 1; c = 1; plot_lab_0 = [373,549];
Use one set of case values at a time. The selected configurations are
fully opaque; background configurations remain transparent.

Compute or load the matching COCO branch before plotting. The listed
labels belong to the corresponding saved runs; check them again after
changing parameters or continuation settings.
