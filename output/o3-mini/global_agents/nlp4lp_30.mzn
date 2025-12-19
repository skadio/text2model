```mzn
include "globals.mzn";

/* Data from the .dzn file */
int: K;                          % Number of departments
int: L;                          % Number of relocation candidate cities
array[1..K, 1..L] of int: Benefit;    % Benefit (in thousands) for relocating department k to candidate city (index l); 
                                      % Note: benefit is only available for candidate cities, not London.
array[1..K, 1..K] of float: Communication;  % Communication volumes between departments
array[1..(L+1), 1..(L+1)] of int: Cost;       % Unit communication cost between locations.
                                              % Locations are numbered 1..(L+1): 1 represents London and 2..(L+1) the candidate cities.

/* Decision Variables */
% location[k] encodes the location chosen for department k:
%  1         --> London (no relocation benefit)
%  2..(L+1)  --> relocation candidate cities
array[1..K] of var 1..(L+1): location;

/* Capacity Constraint: No location may have more than 3 departments */
array[1..(L+1)] of int: lo = [0 | i in 1..(L+1)];
array[1..(L+1)] of int: up = [3 | i in 1..(L+1