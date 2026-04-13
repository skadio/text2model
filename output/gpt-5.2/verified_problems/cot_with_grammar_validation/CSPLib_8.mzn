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
array[1..n_containers] of var 0..deck_width: x;   % left coordinate
array[1..n_containers] of var 0..deck_length: y;  % bottom coordinate

% Constraints
constraint forall(i in 1..n_containers) (width[i] >= 0 /\ length[i] >= 0);
constraint forall(i in 1..n_containers) (class[i] >= 1 /\ class[i] <= n_classes);
constraint forall(a in 1..n_classes, b in 1..n_classes) (separation[a,b] >= 0);

% Stay within deck
constraint forall(i in 1..n_containers) (x[i] + width[i] <= deck_width);
constraint forall(i in 1..n_containers) (y[i] + length[i] <= deck_length);

% Non-overlap (rectangles axis-aligned)
constraint forall(i, j in 1..n_containers where i < j) (
  x[i] + width[i] <= x[j] \/
  x[j] + width[j] <= x[i] \/
  y[i] + length[i] <= y[j] \/
  y[j] + length[j] <= y[i]
);

% Separation constraints between different classes:
% Enforce that along x OR along y, the rectangles are separated by at least separation[class[i], class[j]]
constraint
  forall(i, j in 1..n_containers where i < j /\ class[i] != class[j]) (
    let {
      int: s = separation[class[i], class[j]]
    } in
      (x[i] + width[i] + s <= x[j]) \/
      (x[j] + width[j] + s <= x[i]) \/
      (y[i] + length[i] + s <= y[j]) \/
      (y[j] + length[j] + s <= y[i])
  );

% Objective
solve satisfy;