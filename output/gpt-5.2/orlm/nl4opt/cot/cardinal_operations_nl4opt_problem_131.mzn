% Parameters (with values embedded)
int: nSyrups = 2;
set of int: S = 1..nSyrups;

array[S] of float: throat_med = [0.5, 0.2];
array[S] of float: lung_med   = [0.4, 0.5];
array[S] of float: sugar      = [0.5, 0.3];

float: throat_max = 5.0;  % at most
float: lung_min   = 4.0;  % at least

% Variables
array[S] of var int: servings;  % number of servings of each syrup
var float: total_throat;
var float: total_lung;
var float: total_sugar;

% Constraints
constraint forall(s in S)(servings[s] >= 0);

constraint total_throat = sum(s in S)(throat_med[s] * int2float(servings[s]));
constraint total_lung   = sum(s in S)(lung_med[s]   * int2float(servings[s]));
constraint total_sugar  = sum(s in S)(sugar[s]      * int2float(servings[s]));

constraint total_throat <= throat_max;
constraint total_lung   >= lung_min;

% Objective
solve minimize total_sugar;