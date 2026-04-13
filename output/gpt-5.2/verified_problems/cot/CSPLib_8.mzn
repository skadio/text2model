% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of int: class;

array[1..n_classes, 1..n_classes] of int: separation;

% Variables
array[1..n_containers] of var 0..deck_width: x;   % left (across deck)
array[1..n_containers] of var 0..deck_length: y;  % bottom (along deck)

% Constraints
constraint forall(i in 1..n_containers) (
  x[i] + width[i] <= deck_width /\
  y[i] + length[i] <= deck_length
);

% Non-overlap (axis-aligned rectangles)
constraint forall(i, j in 1..n_containers where i < j) (
  x[i] + width[i] <= x[j] \/
  x[j] + width[j] <= x[i] \/
  y[i] + length[i] <= y[j] \/
  y[j] + length[j] <= y[i]
);

% Separation constraints between classes:
% Require at least separation[c1,c2] gap along x OR along y (disjunctive).
% Implemented by expanding one of the non-overlap directions by the required gap.
constraint forall(i, j in 1..n_containers where i < j) (
  let {
    int: c1 = class[i],
    int: c2 = class[j],
    int: sep = separation[c1, c2]
  } in
    x[i] + width[i] + sep <= x[j] \/
    x[j] + width[j] + sep <= x[i] \/
    y[i] + length[i] + sep <= y[j] \/
    y[j] + length[j] + sep <= y[i]
);

% Objective
solve satisfy;