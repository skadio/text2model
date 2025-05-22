% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;          % width of each container
array[1..n_containers] of int: length;         % length of each container
array[1..n_containers] of 1..n_classes: class; % class of each container

array[1..n_classes, 1..n_classes] of int: separation; % minimum separations between classes


% Variables
array[1..n_containers] of var 0..deck_width:  x; % x–coordinate (across the deck)
array[1..n_containers] of var 0..deck_length: y; % y–coordinate (along   the deck)

array[1..n_containers, 1..n_containers] of var bool: left;   % i is strictly left   of j
array[1..n_containers, 1..n_containers] of var bool: right;  % i is strictly right  of j
array[1..n_containers, 1..n_containers] of var bool: above;  % i is strictly above  of j
array[1..n_containers, 1..n_containers] of var bool: below;  % i is strictly below  of j


% Constraints
% 1. Containers must lie completely inside the deck.
constraint
  forall(i in 1..n_containers) (
        x[i] + width[i]  <= deck_width /\
        y[i] + length[i] <= deck_length
  );

% 2. Mutual exclusivity of relative positions and required separations.
constraint
  forall(i, j in 1..n_containers where i < j) (
     let { int: sep = separation[class[i], class[j]] } in
        left[i,j] + right[i,j] + above[i,j] + below[i,j] = 1 /\
        (left[i,j]  -> x[i] + width[i]  + sep <= x[j]) /\
        (right[i,j] -> x[j] + width[j]  + sep <= x[i]) /\
        (below[i,j] -> y[i] + length[i] + sep <= y[j]) /\
        (above[i,j] -> y[j] + length[j] + sep <= y[i])
  );

% 3. Symmetry between opposite relations.
constraint
  forall(i, j in 1..n_containers where i < j) (
        left[i,j] = right[j,i] /\
        right[i,j] = left[j,i] /\
        above[i,j] = below[j,i] /\
        below[i,j] = above[j,i]
  );

% 4. No orientation is assigned for a container with itself.
constraint
  forall(i in 1..n_containers) (
        left[i,i]  = false /\
        right[i,i] = false /\
        above[i,i] = false /\
        below[i,i] = false
  );


% Objective
solve satisfy;