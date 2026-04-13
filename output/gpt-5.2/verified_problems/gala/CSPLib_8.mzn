include "globals.mzn";

%----------------------------
% Input data (from .dzn)
%----------------------------
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of int: class; % in 1..n_classes

% Minimum separation required between class a and class b (a,b in 1..n_classes)
array[1..n_classes, 1..n_classes] of int: separation;

%----------------------------
% Decision variables
%----------------------------
array[1..n_containers] of var 0..deck_width:  x; % left coordinate
array[1..n_containers] of var 0..deck_length: y; % bottom coordinate

% Ensure containers fit within the deck
constraint forall(i in 1..n_containers) (
  x[i] + width[i]  <= deck_width /\
  y[i] + length[i] <= deck_length
);

%----------------------------
% Non-overlap constraints (rectangles axis-aligned)
%----------------------------
constraint forall(i, j in 1..n_containers where i < j) (
  (x[i] + width[i]  <= x[j]) \/
  (x[j] + width[j]  <= x[i]) \/
  (y[i] + length[i] <= y[j]) \/
  (y[j] + length[j] <= y[i])
);

%----------------------------
% Separation constraints between classes
%
% Interpreted as: for any two containers i,j, if their classes require
% separation d>0, then they must be at least d apart in x OR at least d apart in y.
% (i.e., a minimum offset along deck or across deck).
%----------------------------
constraint forall(i, j in 1..n_containers where i < j) (
  let {
    int: d = separation[class[i], class[j]]
  } in
    d <= 0 \/
    ( abs(x[i] - x[j]) >= d \/
      abs(y[i] - y[j]) >= d )
);

solve satisfy;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n"
];