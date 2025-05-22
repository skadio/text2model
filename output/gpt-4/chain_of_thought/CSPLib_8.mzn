% Parameters
int: deck_width; % Width of the deck
int: deck_length; % Length of the deck
int: n_containers; % Number of containers to be loaded
int: n_classes; % Number of unique container classes
array[1..n_containers] of int: width; % Array of widths of each container
array[1..n_containers] of int: length; % Array of lengths of each container
array[1..n_containers] of int: class; % Array specifying the class of each container
array[1..n_classes, 1..n_classes] of int: separation; % Array specifying the minimum allowed separation between containers of different classes

% Variables
array[1..n_containers] of var 1..deck_width: x; % x-coordinate of the bottom-left corner of each container
array[1..n_containers] of var 1..deck_length: y; % y-coordinate of the bottom-left corner of each container

% Constraints
constraint forall(i in 1..n_containers)(
  x[i] + width[i] <= deck_width + 1 /\ y[i] + length[i] <= deck_length + 1
); % Each container must fit within the deck

constraint forall(i in 1..n_containers, j in i+1..n_containers)(
  (x[i] + width[i] <= x[j] - separation[class[i], class[j]] \/ x[j] + width[j] <= x[i] - separation[class[i], class[j]]) \/
  (y[i] + length[i] <= y[j] - separation[class[i], class[j]] \/ y[j] + length[j] <= y[i] - separation[class[i], class[j]])
); % Containers of different classes must be separated by the minimum allowed distance

% Objective
solve satisfy;