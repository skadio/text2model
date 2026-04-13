% Parameters
int: deck_width;            % Width of the deck (along x/across)
int: deck_length;           % Length of the deck (along y/along)

int: n_containers;          % Number of containers to place
int: n_classes;             % Number of container classes

set of int: CONTAINERS = 1..n_containers;   % Container index set
set of int: CLASSES = 1..n_classes;         % Class index set

array[CONTAINERS] of int: width;            % width[i] = container i width
array[CONTAINERS] of int: length;           % length[i] = container i length
array[CONTAINERS] of int: class;            % class[i] in CLASSES = class of container i

array[CLASSES, CLASSES] of int: separation; % separation[c1,c2] = min separation required


% Variables
array[CONTAINERS] of var 0..deck_width:  x;       % x-coordinate (left) of container i
array[CONTAINERS] of var 0..deck_length: y;       % y-coordinate (bottom) of container i

array[CONTAINERS] of var 0..deck_width:  x_end;   % x_end[i] = x[i] + width[i]
array[CONTAINERS] of var 0..deck_length: y_end;   % y_end[i] = y[i] + length[i]

% Non-overlap relative position binaries for each ordered pair (i<j)
array[CONTAINERS, CONTAINERS] of var bool: left_of;   % i strictly left of j
array[CONTAINERS, CONTAINERS] of var bool: right_of;  % i strictly right of j
array[CONTAINERS, CONTAINERS] of var bool: below;     % i strictly below j
array[CONTAINERS, CONTAINERS] of var bool: above;     % i strictly above j

% Separation direction choice binaries for each ordered pair (i<j)
array[CONTAINERS, CONTAINERS] of var bool: sep_x;   % separation enforced along x-direction
array[CONTAINERS, CONTAINERS] of var bool: sep_y;   % separation enforced along y-direction


% Constraints

%------------------------------------------------------------
% Derived geometry: end coordinates
%------------------------------------------------------------
constraint
  forall(i in CONTAINERS) (
    x_end[i] = x[i] + width[i] /\
    y_end[i] = y[i] + length[i]
  );

%------------------------------------------------------------
% Stay within deck boundaries
%------------------------------------------------------------
constraint
  forall(i in CONTAINERS) (
    x[i] >= 0 /\ y[i] >= 0 /\
    x_end[i] <= deck_width /\
    y_end[i] <= deck_length
  );

%------------------------------------------------------------
% Pairwise non-overlap: for each unordered pair choose a relative position
%------------------------------------------------------------
constraint
  forall(i, j in CONTAINERS where i < j) (
    % exactly one of the four relative relations holds
    bool2int(left_of[i,j]) + bool2int(right_of[i,j]) +
    bool2int(below[i,j])   + bool2int(above[i,j]) = 1
  );

%------------------------------------------------------------
% Non-overlap implications (strict separation by geometry)
%------------------------------------------------------------
constraint
  forall(i, j in CONTAINERS where i < j) (
    (left_of[i,j]  -> x_end[i] <= x[j]) /\
    (right_of[i,j] -> x_end[j] <= x[i]) /\
    (below[i,j]    -> y_end[i] <= y[j]) /\
    (above[i,j]    -> y_end[j] <= y[i])
  );

%------------------------------------------------------------
% Separation constraint direction choice (if separation required)
% If containers' classes require a positive separation, enforce it either
% along x or along y (at least one direction must be chosen).
%------------------------------------------------------------
constraint
  forall(i, j in CONTAINERS where i < j) (
    let { int: s = separation[class[i], class[j]] } in
      (s <= 0) \/
      (sep_x[i,j] \/ sep_y[i,j])
  );

%------------------------------------------------------------
% Separation distance enforcement along x-direction (if chosen)
% Requires containers to be s apart along x in either left/right order.
%------------------------------------------------------------
constraint
  forall(i, j in CONTAINERS where i < j) (
    let { int: s = separation[class[i], class[j]] } in
      sep_x[i,j] ->
        (x_end[i] + s <= x[j] \/ x_end[j] + s <= x[i])
  );

%------------------------------------------------------------
% Separation distance enforcement along y-direction (if chosen)
% Requires containers to be s apart along y in either below/above order.
%------------------------------------------------------------
constraint
  forall(i, j in CONTAINERS where i < j) (
    let { int: s = separation[class[i], class[j]] } in
      sep_y[i,j] ->
        (y_end[i] + s <= y[j] \/ y_end[j] + s <= y[i])
  );


% Objective
solve satisfy;