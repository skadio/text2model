var int: drop1_x, drop1_y, drop2_x, drop2_y;

% Ensure the two drop points are distinct
constraint drop1_x != drop2_x \/ drop1_y != drop2_y;

% Objective: minimize the total distance from the two drop points to the
% nearest houses
var int: total_distance;
constraint total_distance = sum(i in 1..n, j in 1..m) (
    min(
        abs(x[i] - drop1_x) + abs(y[i] - drop1_y),
        abs(x[i] - drop2_x) + abs(y[i] - drop2_y)
    )
);
solve minimize total_distance;

output [
    "Drop point 1: (", show(drop1_x), ", ", show(drop1_y), ")\n",
    "Drop point 2: (", show(drop2_x), ", ", show(drop2_y), ")\n",
    "Total distance: ", show(total_distance), "\n"
];