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
array[1..n_containers] of var 1..deck_width: x; % x-coordinate of the bottom-left corner of each container
array[1..n_containers] of var 1..deck_length: y; % y-coordinate of the bottom-left corner of each container

% Constraints
% Containers must fit within the deck
constraint forall(i in 1..n_containers) (
  x[i] + width[i] <= deck_width + 1 /\ y[i] + length[i] <= deck_length + 1
);

% Containers must not overlap
constraint forall(i in 1..n_containers, j in i+1..n_containers) (
  x[i] + width[i] <= x[j] \/ x[j] + width[j] <= x[i] \/ y[i] + length[i] <= y[j] \/ y[j] + length[j] <= y[i]
);

% Containers of different classes must be separated by the minimum distance
constraint forall(i in 1..n_containers, j in i+1..n_containers) (
  if class[i] != class[j] then
    abs(x[i] - x[j]) >= separation[class[i], class[j]] \/ abs(y[i] - y[j]) >= separation[class[i], class[j]]
  else
    true
  endif
);

% Objective
solve satisfy;