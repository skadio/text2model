% Parameters
int: gas_available = 1000;          % Total units of rare inert gas available
int: water_available = 800;         % Total units of treated water available

int: gas_per_A = 5;                 % Gas required per reaction A
int: water_per_A = 6;               % Water required per reaction A
int: compound_per_A = 10;           % Compound produced per reaction A

int: gas_per_B = 7;                 % Gas required per reaction B
int: water_per_B = 3;               % Water required per reaction B
int: compound_per_B = 8;            % Compound produced per reaction B

% Variables
var 0..(gas_available div gas_per_A): num_reaction_A;   % Number of times to run reaction A
var 0..(gas_available div gas_per_B): num_reaction_B;   % Number of times to run reaction B

% Upper bound uses gas-only maxima; water constraints will further restrict feasibility.
var 0..(compound_per_A * (gas_available div gas_per_A)
       + compound_per_B * (gas_available div gas_per_B)): total_compound; % Total produced compound

% Constraints
% Resource constraint: total rare inert gas used by reactions A and B cannot exceed availability
constraint
  gas_per_A * num_reaction_A + gas_per_B * num_reaction_B <= gas_available;

% Resource constraint: total treated water used by reactions A and B cannot exceed availability
constraint
  water_per_A * num_reaction_A + water_per_B * num_reaction_B <= water_available;

% Accounting constraint: total compound equals sum of compound produced by each reaction type
constraint
  total_compound =
    compound_per_A * num_reaction_A + compound_per_B * num_reaction_B;

% Objective
solve maximize total_compound;