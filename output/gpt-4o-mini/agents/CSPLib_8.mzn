include "globals.mzn";

int: deck_width;                     % Width of the deck
int: deck_length;                    % Length of the deck
int: n_containers;                   % Number of containers
int: n_classes;                      % Number of unique container classes
array[1..n_containers] of int: width;  % Widths of each container
array[1..n_containers] of int: length; % Lengths of each container
array[1..n_containers] of int: class;  % Class of each container
array[1..n_classes, 1..n_classes] of int: separation; % Minimum separation

% Variables for the position of each container
array[1..n_containers] of var 0..deck_width: x;  % x-coordinates
array[1..n_containers] of var 0..deck_length: y; % y-coordinates

% Constraints to ensure containers do not overlap
constraint forall(i, j in 1..n_containers where i < j)(
    (x[i] + width[i] <= x[j] \/ x[j] + width[j] <= x[i] \/ 
     y[i] + length[i] <= y[j] \/ y[j] + length[j] <= y[i]) 
    \/ (class[i] != class[j] -> 
        (abs(x[i] - x[j]) >= separation[class[i], class[j]] \/ 
         abs(y[i] - y[j]) >= separation[class[i], class[j]]))
);

% Ensure all containers are within the deck boundaries
constraint forall(i in 1..n_containers)(
    x[i] + width[i] <= deck_width /\ 
    y[i] + length[i] <= deck_length
);

% Solve and output the positions of the containers
solve satisfy;
output [ "Container ", show(i), ": (", show(x[i]), ", ", show(y[i]), ")\n" | i in 1..n_containers ];