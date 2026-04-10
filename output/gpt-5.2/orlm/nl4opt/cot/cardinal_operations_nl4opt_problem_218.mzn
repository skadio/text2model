% Parameters (with values embedded)
int: gold_available = 500;
int: wires_available = 300;

int: gold_A = 3;
int: wires_A = 2;
int: coins_A = 5;

int: gold_B = 5;
int: wires_B = 3;
int: coins_B = 7;

% Variables
var 0..(gold_available div gold_A): xA; % number of process A runs
var 0..(gold_available div gold_B): xB; % number of process B runs

% Constraints
constraint gold_A * xA + gold_B * xB <= gold_available;
constraint wires_A * xA + wires_B * xB <= wires_available;

% Objective
var int: total_coins = coins_A * xA + coins_B * xB;
solve maximize total_coins;

output [
  "Process A runs = ", show(xA), "\n",
  "Process B runs = ", show(xB), "\n",
  "Total coins plated = ", show(total_coins), "\n"
];