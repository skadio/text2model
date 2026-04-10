% Supply vessel deck loading with separation constraints (satisfaction)

% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of int: class;

array[1..n_classes, 1..n_classes] of int: separation;

% Variables: bottom-left corner of each container
array[1..n_containers] of var 0..deck_width: x;
array[1..n_containers] of var 0..deck_length: y;

% Basic validity
constraint forall(i in 1..n_containers) (
  1 <= class[i] /\ class[i] <= n_classes
);

constraint forall(i in 1..n_containers) (
  width[i] > 0 /\ length[i] > 0
);

% Inside deck bounds
constraint forall(i in 1..n_containers) (
  x[i] + width[i] <= deck_width /\
  y[i] + length[i] <= deck_length
);

% Non-overlap for all pairs (axis-aligned rectangles)
constraint forall(i, j in 1..n_containers where i < j) (
  x[i] + width[i] <= x[j] \/
  x[j] + width[j] <= x[i] \/
  y[i] + length[i] <= y[j] \/
  y[j] + length[j] <= y[i]
);

% Separation constraints between classes:
% Require at least sep gap in x OR in y (edge-to-edge distance).
constraint forall(i, j in 1..n_containers where i < j) (
  let {
    int: ci = class[i],
    int: cj = class[j],
    int: sep = separation[ci, cj]
  } in
    sep <= 0 \/
    (x[i] + width[i] + sep <= x[j]) \/
    (x[j] + width[j] + sep <= x[i]) \/
    (y[i] + length[i] + sep <= y[j]) \/
    (y[j] + length[j] + sep <= y[i])
);

solve satisfy;