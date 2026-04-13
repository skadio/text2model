% Parameters
int: gold_available = 500;        % total units of gold available
int: wires_available = 300;       % total wires available

int: gold_per_A = 3;              % gold units required per process A
int: wires_per_A = 2;             % wires required per process A
int: coins_per_A = 5;             % coins plated per process A

int: gold_per_B = 5;              % gold units required per process B
int: wires_per_B = 3;             % wires required per process B
int: coins_per_B = 7;             % coins plated per process B

% Variables
% Upper bounds derived from independent resource limits for each process type
var 0..min(gold_available div gold_per_A, wires_available div wires_per_A): nA;  % number of process A runs
var 0..min(gold_available div gold_per_B, wires_available div wires_per_B): nB;  % number of process B runs

% Total coins plated (bounded by a safe gold-only based upper bound)
var 0..(coins_per_A * (gold_available div gold_per_A) + coins_per_B * (gold_available div gold_per_B)): total_coins;

% Constraints
% Resource capacity constraints (do not exceed available gold and wires)
constraint gold_per_A * nA + gold_per_B * nB <= gold_available;
constraint wires_per_A * nA + wires_per_B * nB <= wires_available;

% Total coins definition (link total_coins to decision variables)
constraint total_coins = coins_per_A * nA + coins_per_B * nB;

% Objective
solve maximize total_coins;