include "globals.mzn";

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
array[1..n_containers] of var 1..deck_width: x;
array[1..n_containers] of var 1..deck_length: y;

% Constraints
constraint forall(i in 1..n_containers, j in i+1..n_containers) (
    x[i] + width[i] <= x[j] + separation[class[i], class[j]] \/ 
    x[j] + width[j] <= x[i] + separation[class[j], class[i]] \/ 
    y[i] + length[i] <= y[j] + separation[class[i], class[j]] \/ 
    y[j] + length[j] <= y[i] + separation[class[j], class[i]]
);

constraint forall(i in 1..n_containers) (
    x[i] + width[i] <= deck_width + 1 /\ 
    y[i] + length[i] <= deck_length + 1
);

% Objective
solve satisfy;