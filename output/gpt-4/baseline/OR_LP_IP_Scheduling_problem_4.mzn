% Size of the grid
int: n;

% Grid representing the location of villagers in need of relief supplies
array[1..n, 1..n] of int: huts;

% Variables representing the coordinates of the two airdrop locations
var 1..n: x1;
var 1..n: y1;
var 1..n: x2;
var 1..n: y2;

% Function to calculate the squared distance between two points
function var int: squared_distance(var int: x1, var int: y1, var int: x2, var int: y2) =
  (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);

% Objective function to minimize the sum of squared distances of huts to their closest relief package destination
var int: total_distance = sum(i in 1..n, j in 1..n) (
  huts[i,j] * min(squared_distance(i, j, x1, y1), squared_distance(i, j, x2, y2))
);

% The objective is to minimize the total distance
solve minimize total_distance;

% Output the coordinates of the two airdrop locations
output ["Airdrop 1: (", show(x1), ", ", show(y1), ")\n",
        "Airdrop 2: (", show(x2), ", ", show(y2), ")\n",
        "Total distance: ", show(total_distance)];