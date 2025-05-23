% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

set of int: CONTAINERS = 1..n_containers;
set of int: CLASSES    = 1..n_classes;

array[CONTAINERS] of int: width;
array[CONTAINERS] of int: length;
array[CONTAINERS] of int: class;

array[CLASSES, CLASSES] of int: separation;

% Variables
array[CONTAINERS] of var 0..deck_width:  x;   % position along deck width  (across)
array[CONTAINERS] of var 0..deck_length: y;   % position along deck length (along)

% Constraints

% Each container must lie completely inside the deck
constraint
  forall(i in CONTAINERS) (
        x[i] + width[i]  <= deck_width
    /\  y[i] + length[i] <= deck_length
  );

% Non-overlap and class-dependent separation between every pair of containers
constraint
  forall(i,j in CONTAINERS where i < j) (
        (x[i] + width[i]  + separation[class[i],class[j]] <= x[j])
    \/  (x[j] + width[j]  + separation[class[i],class[j]] <= x[i])
    \/  (y[i] + length[i] + separation[class[i],class[j]] <= y[j])
    \/  (y[j] + length[j] + separation[class[i],class[j]] <= y[i])
  );

% Objective
solve satisfy;