% Parameters
int: deck_width;                 % Width of the rectangular deck
int: deck_length;                % Length of the rectangular deck

int: n_containers;               % Number of containers to place
int: n_classes;                  % Number of container classes

% NOTE: widths/lengths are per CONTAINER (to match provided data, e.g. [5,2,3] for 3 containers),
% not per class.
array[1..n_containers] of int: width;       % Width of each container
array[1..n_containers] of int: length;      % Length of each container
array[1..n_containers] of int: class;       % Class of each container (1..n_classes)

array[1..n_classes, 1..n_classes] of int: separation;  % Min separation requirement between classes


% Variables
array[1..n_containers] of var 0..deck_width: x;    % x-coordinate of lower-left corner
array[1..n_containers] of var 0..deck_length: y;   % y-coordinate of lower-left corner


% Constraints

%-----------------------------
% Keep each container fully within the deck boundaries
%-----------------------------
constraint
  forall(i in 1..n_containers) (
    x[i] + width[i]  <= deck_width /\
    y[i] + length[i] <= deck_length
  );

%-----------------------------
% Non-overlap between any pair of containers (single layer packing)
%-----------------------------
constraint
  forall(i, j in 1..n_containers where i < j) (
    x[i] + width[i]  <= x[j] \/
    x[j] + width[j]  <= x[i] \/
    y[i] + length[i] <= y[j] \/
    y[j] + length[j] <= y[i]
  );

%-----------------------------
% Separation constraints between classes:
% Enforce minimum separation (gap) either in x OR in y direction.
%-----------------------------
constraint
  forall(i, j in 1..n_containers where i < j) (
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