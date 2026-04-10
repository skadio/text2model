% Largest inscribed circle in a convex polygon (maximize radius).
% Data embedded from the problem statement.

int: n = 8;
set of int: V = 1..n;

array[V] of float: px = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[V] of float: py = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0];

float: xmin = 0.0;
float: xmax = 11.0;
float: ymin = 0.0;
float: ymax = 10.0;

% Use built-in acos to define pi (MiniZinc has no predefined 'pi' constant).
float: PI = 2.0 * acos(0.0);

var xmin..xmax: cx;
var ymin..ymax: cy;

var 0.0..max(xmax - xmin, ymax - ymin): r;

% Circle inside polygon: for each CCW edge, signed distance from center to edge >= r
constraint
  forall(i in V) (
    let {
      int: j = if i < n then i + 1 else 1 endif,
      float: dx = px[j] - px[i],
      float: dy = py[j] - py[i],
      float: len = sqrt(dx*dx + dy*dy)
    } in
      dx * (cy - py[i]) - dy * (cx - px[i]) >= r * len
  );

% Redundant but helpful bounds tightening
constraint
  cx >= xmin + r /\ cx <= xmax - r /\
  cy >= ymin + r /\ cy <= ymax - r;

% Maximizing area is equivalent to maximizing radius (area = PI * r^2).
solve maximize r;

output [
  "cx=", show(cx), " cy=", show(cy), " r=", show(r), "\n",
  "area=", show(PI * r * r), "\n"
];