include "globals.mzn";

int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of int: class;          % values in 1..n_classes

array[1..n_classes, 1..n_classes] of int: separation;  % minimum separation (same units as coordinates)

set of int: C = 1..n_containers;

array[C] of var 0..deck_width:  x;   % left coordinate
array[C] of var 0..deck_length: y;   % bottom coordinate

constraint
  forall(i in C) (
    x[i] + width[i]  <= deck_width /\
    y[i] + length[i] <= deck_length
  );

% Non-overlap constraints (axis-aligned rectangles)
constraint
  forall(i, j in C where i < j) (
    x[i] + width[i]  <= x[j] \/
    x[j] + width[j]  <= x[i] \/
    y[i] + length[i] <= y[j] \/
    y[j] + length[j] <= y[i]
  );

% Separation constraints for different classes:
% Require either sufficient horizontal gap OR sufficient vertical gap.
% For pairs with required separation = 0, this reduces to always true.
constraint
  forall(i, j in C where i < j) (
    let {
      int: sep_ij = separation[class[i], class[j]]
    } in
      (sep_ij <= 0) \/
      (x[i] + width[i] + sep_ij <= x[j]) \/
      (x[j] + width[j] + sep_ij <= x[i]) \/
      (y[i] + length[i] + sep_ij <= y[j]) \/
      (y[j] + length[j] + sep_ij <= y[i])
  );

solve satisfy;

output [
  "x = ", show(x), ";\n",
  "y = ", show(y), ";\n"
];