% Parameters
int: total_medicinal_units = 1000;          % Total available medicinal ingredient units

int: med_per_large = 3;                    % Medicinal units needed per large pill
int: filler_per_large = 2;                 % Filler units needed per large pill

int: med_per_small = 2;                    % Medicinal units needed per small pill
int: filler_per_small = 1;                 % Filler units needed per small pill

int: min_large_pills = 100;                % Minimum number of large pills required
int: min_small_percent = 60;               % At least this percent of total pills must be small

% Derived upper bounds (from medicinal ingredient limit)
int: max_large_by_med = total_medicinal_units div med_per_large;  % floor(1000/3)
int: max_small_by_med = total_medicinal_units div med_per_small;  % floor(1000/2)

% Variables
var min_large_pills..max_large_by_med: num_large;  % Number of large pills to produce
var 0..max_small_by_med: num_small;                % Number of small pills to produce

var 0..(filler_per_large*max_large_by_med + filler_per_small*max_small_by_med): total_filler;
                                                   % Total filler material used

% Constraints
% Medicinal ingredient capacity: cannot exceed available medicinal units
constraint
  med_per_large * num_large + med_per_small * num_small <= total_medicinal_units;

% Popularity requirement: at least min_small_percent% of all pills are small
% 100 * num_small >= min_small_percent * (num_large + num_small)
constraint
  100 * num_small >= min_small_percent * (num_large + num_small);

% Define total filler usage based on production quantities
constraint
  total_filler = filler_per_large * num_large + filler_per_small * num_small;

% Objective
solve minimize total_filler;