# ``PathWarp/PointType``

You may not want to warp all elements on a shape.

If you want to warp just the line start/finish points, provide:

```
.joint
```

If you want to warp the control points of bezier curves, provide:

```
.control
```

By default, we warp everything, which is equivalent to the following option

```
.all
```

