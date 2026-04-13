% Parameters
int: max_total_hours = 50;                 % Total man-hours available across tasks X, Y, Z
int: min_quality_measure = 100;            % Minimum required value of (3*X + 4*Y + 1*Z)
int: max_secondary_measure = 75;           % Maximum allowed value of (2*X - Y + Z)

int: coeff_quality_X = 3;                  % Coefficient of X in quality measure
int: coeff_quality_Y = 4;                  % Coefficient of Y in quality measure
int: coeff_quality_Z = 1;                  % Coefficient of Z in quality measure

int: coeff_secondary_X = 2;                % Coefficient of X in secondary measure
int: coeff_secondary_Y = -1;               % Coefficient of Y in secondary measure
int: coeff_secondary_Z = 1;                % Coefficient of Z in secondary measure

int: cost_X = 100;                         % Cost per hour of task X
int: cost_Y = 200;                         % Cost per hour of task Y
int: cost_Z = 150;                         % Cost per hour of task Z

% Variables
var 0..max_total_hours: hours_X;            % Integer man-hours allocated to task X
var 0..max_total_hours: hours_Y;            % Integer man-hours allocated to task Y
var 0..max_total_hours: hours_Z;            % Integer man-hours allocated to task Z

var 0..(cost_X*max_total_hours + cost_Y*max_total_hours + cost_Z*max_total_hours): total_cost;
                                            % Total cost to minimize (bounded using max_total_hours)

% Constraints
% --- Total hours availability constraint ---
constraint
    hours_X + hours_Y + hours_Z <= max_total_hours;

% --- Quality / combined effort requirement (minimum) ---
constraint
    coeff_quality_X * hours_X
  + coeff_quality_Y * hours_Y
  + coeff_quality_Z * hours_Z
  >= min_quality_measure;

% --- Secondary measure requirement (maximum) ---
constraint
    coeff_secondary_X * hours_X
  + coeff_secondary_Y * hours_Y
  + coeff_secondary_Z * hours_Z
  <= max_secondary_measure;

% --- Total cost definition ---
constraint
    total_cost =
        cost_X * hours_X
      + cost_Y * hours_Y
      + cost_Z * hours_Z;

% Objective
solve minimize total_cost;

% Optional output (helps interpret solution)
output [
  "hours_X = ", show(hours_X), "\n",
  "hours_Y = ", show(hours_Y), "\n",
  "hours_Z = ", show(hours_Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];