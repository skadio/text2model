% Parameters
int: max_total_tours = 500;          % Maximum total number of tours allowed
int: min_diversity_score = 1000;     % Minimum required value of (3*X + 2*Y)
int: max_difference = 200;           % Maximum allowed absolute difference |X - Y|
int: coeff_x = 3;                    % Diversity coefficient for tour X
int: coeff_y = 2;                    % Diversity coefficient for tour Y
int: cost_x = 50;                    % Cost per tour X (dollars)
int: cost_y = 30;                    % Cost per tour Y (dollars)

% Variables
var 0..max_total_tours: toursX;      % Number of type X tours (integer, nonnegative)
var 0..max_total_tours: toursY;      % Number of type Y tours (integer, nonnegative)
var 0..(cost_x*max_total_tours + cost_y*max_total_tours): totalCost; % Total cost (dollars)

% Constraints
% Total number of tours cannot exceed the resource limit
constraint toursX + toursY <= max_total_tours;

% Diversity requirement: coeff_x * X + coeff_y * Y must meet minimum threshold
constraint coeff_x * toursX + coeff_y * toursY >= min_diversity_score;

% Balance requirement: absolute difference between X and Y tours bounded
constraint abs(toursX - toursY) <= max_difference;

% Define total cost based on chosen numbers of tours
constraint totalCost = cost_x * toursX + cost_y * toursY;

% Objective
solve minimize totalCost;