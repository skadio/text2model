% Parameters
int: deck_width; % Width of the deck
int: deck_length; % Length of the deck
int: n_containers; % Number of containers to be loaded
int: n_classes; % Number of unique container classes
array[1..n_classes] of int: width; % Array of widths of each container
array[1..n_classes] of int: length; % Array of lengths of each container
array[1..n_containers] of int: class; % Array specifying the class of each container
array[1..n_classes, 1..n_classes] of int: separation; % Array specifying the minimum allowed separation between containers of different classes

% Variables
array[1..n_containers] of var 1..deck_width: x; % x-coordinate of the bottom-left corner of each container
array[1..n_containers] of var 1..deck_length: y; % y-coordinate of the bottom-left corner of each container

% Constraints

% Ensure that each container fits within the deck
constraint forall(i in 1..n_containers) (
  x[i] + width[class[i]] <= deck_width + 1 /\ 
  y[i] + length[class[i]] <= deck_length + 1
);

% Ensure that no two containers overlap
constraint forall(i in 1..n_containers, j in i+1..n_containers) (
  x[i] + width[class[i]] <= x[j] \/ 
  x[j] + width[class[j]] <= x[i] \/ 
  y[i] + length[class[i]] <= y[j] \/ 
  y[j] + length[class[j]] <= y[i]
);

% Ensure that containers of different classes are separated by the required distance
constraint forall(i in 1..n_containers, j in i+1..n_containers) (
  if class[i] != class[j] then
    x[i] + width[class[i]] + separation[class[i], class[j]] <= x[j] \/ 
    x[j] + width[class[j]] + separation[class[j], class[i]] <= x[i] \/ 
    y[i] + length[class[i]] + separation[class[i], class[j]] <= y[j] \/ 
    y[j] + length[class[j]] + separation[class[j], class[i]] <= y[i]
  else
    true
  endif
);

% Objective
solve satisfy;