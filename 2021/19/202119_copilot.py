from dataclasses import dataclass
from math import cos, sin
import numpy as np

def radians(degrees):
    return degrees * 3.141592653589793 / 180.0
    
@dataclass
class Point:
    """A point in 3D space."""
    x: int
    y: int
    z: int

def rotate(p, r):
    """Rotate a Point p by a rotation matrix r."""
    return Point(
        x=p.x * r[0,0] + p.y * r[0,1] + p.z * r[0,2],
        y=p.x * r[1,0] + p.y * r[1,1] + p.z * r[1,2],
        z=p.x * r[2,0] + p.y * r[2,1] + p.z * r[2,2],
    )


def gen_rotation(axis, angle):
    """Generate a rotation matrix for a given axis and angle (in degrees)."""
    angle = radians(angle)
    if axis == 'x':
        return [
            [1, 0, 0],
            [0, cos(angle), -sin(angle)],
            [0, sin(angle), cos(angle)],
        ]
    elif axis == 'y':
        return [
            [cos(angle), 0, sin(angle)],
            [0, 1, 0],
            [-sin(angle), 0, cos(angle)],
            ]
    else:
        return [
            [cos(angle), -sin(angle), 0],
            [sin(angle), cos(angle), 0],
            [0, 0, 1],
        ]

def round_r(r):
    """Round a rotation matrix to 10 decimal places."""
    return np.array(r).round(10).astype(int)

def get_rotations():
    """Generate all possible rotations."""
    base_rotations = [('z', [0]), ('z', [180])]
    for xr in [0, 90, 180, 270]:
        base_rotations.append(('zx', [90, xr]))
    all_rotations = []
    for br in base_rotations:
        for yr in [0, 90, 180, 270]:
            axs, angs = br
            r = (axs + 'y', angs + [yr])
            all_rotations.append(r)
    rotations = [
        gen_rotation(axs, ang) for ang in angs
        for axs, angs in all_rotations]
    return [round_r(r) for r in rotations]

print(get_rotations())
