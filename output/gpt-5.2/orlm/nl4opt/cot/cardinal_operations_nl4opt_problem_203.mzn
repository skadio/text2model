% Parameters (with values embedded)
int: lab_newspapers = 7;
int: gold_newspapers = 10;
int: lab_treats = 5;
int: gold_treats = 6;
int: treats_available = 1500;

int: min_golden = 50;
int: lab_max_percent = 60;

% Variables
var 0..treats_available div lab_treats: labradors;
var min_golden..treats_available div gold_treats: golden_retrievers;

var 0..(lab_newspapers*(treats_available div lab_treats) + gold_newspapers*(treats_available div gold_treats)): total_newspapers;

% Constraints
constraint lab_treats * labradors + gold_treats * golden_retrievers <= treats_available;

% At most 60% of the dogs can be labradors:
% labradors / (labradors + golden_retrievers) <= 0.6  <=>  5*labradors <= 3*golden_retrievers
constraint 5 * labradors <= 3 * golden_retrievers;

constraint total_newspapers = lab_newspapers * labradors + gold_newspapers * golden_retrievers;

% Objective
solve maximize total_newspapers;