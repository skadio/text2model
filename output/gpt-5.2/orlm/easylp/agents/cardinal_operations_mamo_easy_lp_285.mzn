% Parameters
int: max_total_tours = 50;              % Operational upper bound on total tours
int: min_total_rating = 100;            % Minimum required combined rating

int: rating_X = 5;                      % Rating per tour of package X
int: rating_Y = 3;                      % Rating per tour of package Y
int: rating_Z = 7;                      % Rating per tour of package Z

int: cost_X = 500;                      % Cost per tour of package X (USD)
int: cost_Y = 300;                      % Cost per tour of package Y (USD)
int: cost_Z = 700;                      % Cost per tour of package Z (USD)

int: min_diff_X_over_Y = 10;            % X must be at least this many tours more than Y


% Variables
var 0..max_total_tours: tours_X;        % Number of tours allocated to package X
var 0..max_total_tours: tours_Y;        % Number of tours allocated to package Y
var 0..max_total_tours: tours_Z;        % Number of tours allocated to package Z

var 0..(cost_X*max_total_tours + cost_Y*max_total_tours + cost_Z*max_total_tours): total_cost;
                                        % Total cost (USD)


% Constraints

% --- Total tours capacity constraint ---
constraint
  tours_X + tours_Y + tours_Z <= max_total_tours;

% --- Minimum combined rating (quality) constraint ---
constraint
  rating_X * tours_X + rating_Y * tours_Y + rating_Z * tours_Z >= min_total_rating;

% --- Diversity / preference constraint: X at least min_diff_X_over_Y more than Y ---
constraint
  tours_X - tours_Y >= min_diff_X_over_Y;

% --- Total cost definition constraint ---
constraint
  total_cost = cost_X * tours_X + cost_Y * tours_Y + cost_Z * tours_Z;


% Objective
solve minimize total_cost;