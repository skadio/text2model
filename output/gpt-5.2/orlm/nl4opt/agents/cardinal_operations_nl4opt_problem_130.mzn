% Parameters
int: items_per_A = 30;              % Items produced per day by one machine A
int: items_per_B = 50;              % Items produced per day by one machine B
int: kwh_per_A   = 100;             % kWh consumed per day by one machine A
int: kwh_per_B   = 120;             % kWh consumed per day by one machine B

int: min_items   = 1000;            % Minimum required items per day
int: max_kwh     = 3000;            % Maximum available kWh per day

float: max_frac_B = 0.30;           % At most this fraction of machines can be type B
int: min_A       = 5;               % At least this many A machines must be used

% Derived bounds (for variable bounding)
int: max_total_machines = max_kwh div min(kwh_per_A, kwh_per_B);  % Upper bound from energy
int: max_A = max_total_machines;    % Loose but safe upper bound
int: max_B = max_total_machines;    % Loose but safe upper bound

% Variables
var min_A..max_A: numA;                  % Number of machines of type A
var 0..max_B:     numB;                  % Number of machines of type B
var 0..max_total_machines: totalMachines;% Total number of machines (A + B)

% Constraints

% Total machines definition (linking variable)
constraint
  totalMachines = numA + numB;

% Production requirement: produce at least the minimum number of items per day
constraint
  items_per_A * numA + items_per_B * numB >= min_items;

% Electricity capacity: total kWh consumed must not exceed available kWh per day
constraint
  kwh_per_A * numA + kwh_per_B * numB <= max_kwh;

% Minimum number of A machines
constraint
  numA >= min_A;

% Fraction of B machines: numB / totalMachines <= max_frac_B
% Avoid division by rewriting: numB <= max_frac_B * totalMachines
% Use integer-safe form by scaling (since max_frac_B = 0.30 = 30/100).
constraint
  100 * numB <= 30 * totalMachines;

% Objective
solve minimize totalMachines;