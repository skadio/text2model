% Parameters
int: gold_available = 500;              % Total units of gold available
int: wires_available = 300;             % Total wires available

int: gold_per_A = 3;                    % Gold units required per process A
int: wires_per_A = 2;                   % Wires required per process A
int: coins_per_A = 5;                   % Coins plated per process A

int: gold_per_B = 5;                    % Gold units required per process B
int: wires_per_B = 3;                   % Wires required per process B
int: coins_per_B = 7;                   % Coins plated per process B

% Variables
var 0..(gold_available div gold_per_A): num_A;   % Number of process A runs
var 0..(gold_available div gold_per_B): num_B;   % Number of process B runs

% Upper bound uses only gold-based maxima for safety; objective will enforce optimality
var 0..(coins_per_A*(gold_available div gold_per_A)
       + coins_per_B*(gold_available div gold_per_B)): total_coins; % Total coins plated

% Constraints
% Resource capacity constraints (cannot exceed available gold and wires)
constraint
    gold_per_A * num_A + gold_per_B * num_B <= gold_available;

constraint
    wires_per_A * num_A + wires_per_B * num_B <= wires_available;

% Total coins accounting (define total_coins from chosen process counts)
constraint
    total_coins = coins_per_A * num_A + coins_per_B * num_B;

% Objective
solve maximize total_coins;