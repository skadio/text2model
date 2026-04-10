% Parameters
int: max_total_tours = 50;                 % Maximum total number of tours (X+Y+Z)
int: rating_X = 5;                        % Rating per tour of package X
int: rating_Y = 3;                        % Rating per tour of package Y
int: rating_Z = 7;                        % Rating per tour of package Z
int: min_total_rating = 100;              % Minimum required total rating
int: min_diff_XY = 10;                    % Require X to be at least 10 more than Y
int: cost_X = 500;                        % Cost per tour of package X (USD)
int: cost_Y = 300;                        % Cost per tour of package Y (USD)
int: cost_Z = 700;                        % Cost per tour of package Z (USD)

% Variables
var 0..max_total_tours: tours_X;           % Number of tours allocated to package X (integer)
var 0..max_total_tours: tours_Y;           % Number of tours allocated to package Y (integer)
var 0..max_total_tours: tours_Z;           % Number of tours allocated to package Z (integer)

var 0..(cost_X*max_total_tours + cost_Y*max_total_tours + cost_Z*max_total_tours): total_cost;
                                           % Total cost (USD), safe upper bound

% Constraints
% Total tours capacity constraint (operational limit)
constraint
  tours_X + tours_Y + tours_Z <= max_total_tours;

% Minimum total rating (quality standards)
constraint
  rating_X * tours_X + rating_Y * tours_Y + rating_Z * tours_Z >= min_total_rating;

% Diversity / preference constraint: X at least 10 more tours than Y
constraint
  tours_X - tours_Y >= min_diff_XY;

% Total cost definition (links decision variables to cost variable)
constraint
  total_cost = cost_X * tours_X + cost_Y * tours_Y + cost_Z * tours_Z;

% Objective
solve minimize total_cost;