include "globals.mzn";

% Parameters (supplied via the .dzn file)
int: deck_width;
int: deck_length;
int: n_containers;
int: n_classes;
array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of int: class;         % each container’s class in 1..n_classes
array[1..n_classes, 1..n_classes] of int: separation;

% Decision Variables
% We assume the containers are placed with their bottom‐left corner at (x[i], y[i]).
% Their positions must be integer values within the bounds of the deck.
array[1..n_containers] of var 0..deck_width: x;
array[1..n_containers] of var 0..deck_length: y;

% Boundary Constraints: Each container must be completely on the deck.
constraint 
  forall(i in 1..n_containers) (
    x[i] + width[i] <= deck_width /\ 
    y[i] + length[i] <= deck_length
  );

% Non-Overlap and Separation Constraints:
%
% For each pair of distinct containers i,j (i<j), we require that they do not overlap.
% In addition, if container i is of class c1 and container j is of class c2, then
% the minimum gap between them must be at least separation[c1, c2] in at least one direction.
%
% This is modeled by requiring that at least one of the following holds:
%   • container i is completely to the left of container j with an extra gap,
%   • container j is completely to the left of container i with an extra gap,
%   • container i is completely below container j with an extra gap, or
%   • container j is completely below container i with an extra gap.
constraint
  forall(i, j in 1..n_containers where i < j)(
    let { int: sep = separation[class[i], class[j]] } in
      ( x[i] + width[i] + sep <= x[j] ) \/
      ( x[j] + width[j] + sep <= x[i] ) \/
      ( y[i] + length[i] + sep <= y[j] ) \/
      ( y[j] + length[j] + sep <= y[i] )
  );

solve satisfy;

output [
  "Container positions:\n",
  concat([ "Container " ++ show(i) ++ ": (x=" ++ show(x[i]) ++ ", y=" ++ show(y[i]) ++ ")\n"
           | i in 1..n_containers ])
];