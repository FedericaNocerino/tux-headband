# Tux Twist-Lock Headband

Parametric OpenSCAD source and STL exports for a curved costume headband with a removable quarter-turn Tux mount.

## Status

**Prototype release candidate — not safety-certified or production-validated.** The source defines matching male and female bayonet geometry, but physical fit, retention, comfort, and strength have not been validated. Do not wear it until the printed parts have been inspected and tested.

## Parts

- `stl/headband_socket.stl` — curved front headband with integrated mounting platform and female socket.
- `stl/male_adapter.stl` — male connector/flange intended to be attached to the underside of the Tux model.
- `stl/fit_coupon.stl` — small socket gauge to test printer clearance before printing the full assembly.
- `stl/assembly_preview.stl` — visual preview only; do not print as one part.
- `tux_twistlock.scad` — editable parametric source for all parts.

All dimensions are in millimetres. The headband is a front arch, not a closed ring; it is a starting geometry and may need resizing for the wearer.

## Export from OpenSCAD

Install OpenSCAD, then run these commands from the repository root:

```bash
mkdir -p stl
openscad -o stl/headband_socket.stl -D 'part="headband_socket"' tux_twistlock.scad
openscad -o stl/male_adapter.stl -D 'part="male_adapter"' tux_twistlock.scad
openscad -o stl/fit_coupon.stl -D 'part="fit_coupon"' tux_twistlock.scad
openscad -o stl/assembly_preview.stl -D 'part="assembly_preview"' tux_twistlock.scad
```

## Intended assembly

1. Print the fit coupon first and test the male connector fit.
2. Print the headband/socket and male adapter separately.
3. Attach the adapter flange to a flat, reinforced underside of the Tux mesh. Do not rely on glue alone if the character is heavy; evaluate a mechanical attachment suitable for the model.
4. Align the two male lugs with the entry slots, insert fully, then rotate approximately 35 degrees to the stop. Reverse to remove.

The geometry uses two opposing lugs and a quarter-turn-style bayonet path. It does **not** include a separately validated spring detent; the stop alone should not be treated as secure against all accidental release. Test retention before wearing.

## Suggested initial print settings

- Material: PETG for the mount; use a flexible, skin-contact-compatible material or add soft end pads if needed.
- Layer height: 0.16–0.20 mm.
- Perimeters: 4 or more.
- Infill: 40–60% for the mount; headband settings depend on filament and printer.
- Print the headband flat on the bed; inspect the ends and socket for cracks or sharp edges.
- Print the male adapter flange-down if your printer can bridge/support the lugs cleanly.

These are starting points, not validated settings. Avoid brittle materials for a wearable part. Never use a cracked or sharp-edged print.

## Fit and safety notes

- The default clearance is a nominal starting point only. Printer calibration, material shrinkage, layer orientation, and slicer settings change the fit.
- Print the fit coupon before the full headband. Adjust `socket_inner_d`, `slot_width`, or lug dimensions in the SCAD file as needed.
- The current headband is a fixed-size geometry, not an adjustable size range.
- Tux should be lightweight and securely attached; a tall/heavy model increases leverage and may pull the band out of place.
- Inspect the part before each use. Do not wear if the lock can disengage under light movement, if the band causes discomfort, or if any part is cracked.
- This project has not undergone formal product safety, material, or wear testing.



## License

Source, CAD files, and generated meshes are offered under the MIT License. See `LICENSE`. 
