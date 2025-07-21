# surface-hanger

## Goal

Hang various lightweight doo-dads in front of a painted surface. (I guess it doesn't have to painted. You do you.)

## Iteration

[rounded-hanger.scad](rounded-hanger.scad), formerly known as `painting-surface-hanging-arm-02.scad` before I started
version controlling this, is the first version of this hanger. It actually did pretty well and is hanging some test
pieces.

Shortcomings of `rounded-hanger`:
- Overly comples in the SCAD and had to iterate on.
- not the friendliest print. It takes a really long time and requires supports.
- bends a bit under the weight of the object it's hanging.

Goals for next design:
- Print on its side with no supports.
- Not fundamentally round. May run minkowski on the end product, but build it with rectangles and triangles.
