% Parameters
int: max_total_properties = 1000;          % Regulatory upper limit on total properties
int: min_single_family = 400;             % Minimum required single-family homes (X)
int: min_multi_family  = 250;             % Minimum required multi-family homes (Y)
int: min_commercial    = 350;             % Minimum required commercial buildings (Z)

int: cost_single_family_k = 200;          % Cost per single-family home in thousand dollars
int: cost_multi_family_k  = 300;          % Cost per multi-family home in thousand dollars
int: cost_commercial_k    = 150;          % Cost per commercial building in thousand dollars


% Variables
var min_single_family..max_total_properties: X;   % Number of single-family homes
var min_multi_family..max_total_properties: Y;    % Number of multi-family homes
var min_commercial..max_total_properties: Z;      % Number of commercial buildings

% Total construction cost in dollars (upper bound: 1000 properties * max unit cost * 1000)
var 0..(max_total_properties * max(cost_single_family_k,
                                  max(cost_multi_family_k, cost_commercial_k)) * 1000): total_cost;


% Constraints
% --- Total properties regulatory limit ---
constraint
  X + Y + Z <= max_total_properties;

% --- Minimum required properties (redundant with variable domains, kept for clarity) ---
constraint
  X >= min_single_family;
constraint
  Y >= min_multi_family;
constraint
  Z >= min_commercial;

% --- Total construction cost definition (in dollars) ---
constraint
  total_cost =
    1000 * (cost_single_family_k * X
          + cost_multi_family_k  * Y
          + cost_commercial_k    * Z);


% Objective
solve minimize total_cost;