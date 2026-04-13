include "globals.mzn";

int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

set of int: CONTAINERS = 1..n_containers;
set of int: CLASSES = 1..n_classes;

array[CONTAINERS] of int: width;
array[CONTAINERS] of int: length;
array[CONTAINERS] of int: class;

array[CLASSES, CLASSES] of int: separation;

% Position of the bottom-left corner of each container (integer grid)
array[CONTAINERS] of var 0..deck_width:  x;
array[CONTAINERS] of var 0..deck_length: y;

% Fit within deck bounds
constraint forall(i in CONTAINERS) (
  x[i] + width[i] <= deck_width /\
  y[i] + length[i] <= deck_length
);

% No overlap between any pair of containers (axis-aligned rectangles)
constraint forall(i, j in CONTAINERS where i < j) (
  (x[i] + width[i] <= x[j]) \/
  (x[j] + width[j] <= x[i]) \/
  (y[i] + length[i] <= y[j]) \/
  (y[j] + length[j] <= y[i])
);

% Separation constraints between classes:
% For containers i and j, enforce either:
% - horizontal separation at least sep (i left of j or j left of i), OR
% - vertical separation at least sep (i below j or j below i).
% sep is determined by their classes.
constraint forall(i, j in CONTAINERS where i < j) (
  let {
    int: sep = separation[class[i], class[j]]
  } in
    (x[i] + width[i] + sep <= x[j]) \/
    (x[j] + width[j] + sep <= x[i]) \/
    (y[i] + length[i] + sep <= y[j]) \/
    (y[j] + length[j] + sep <= y[i])
);

solve satisfy;

output [
  "SAT\n",
  "deck_width=", show(deck_width), " deck_length=", show(deck_length), "\n",
  "x=", show(x), "\n",
  "y=", show(y), "\n"
];