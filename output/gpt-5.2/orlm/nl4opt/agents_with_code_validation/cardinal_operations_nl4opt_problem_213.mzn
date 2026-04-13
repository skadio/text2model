% Parameters
int: escalator_capacity = 20;          % people per minute per escalator
int: elevator_capacity  = 8;           % people per minute per elevator
int: escalator_space    = 5;           % space units per escalator
int: elevator_space     = 2;           % space units per elevator

int: min_total_capacity = 400;         % required people per minute overall
int: min_elevators      = 2;           % at least this many elevators
int: escalator_ratio    = 3;           % escalators must be at least 3 times elevators

% Upper bounds derived from capacity requirement (safe, finite bounds)
int: max_escalators = (min_total_capacity div escalator_capacity) + 1;
int: max_elevators  = (min_total_capacity div elevator_capacity) + 1;

% Variables
var 0..max_escalators: num_escalators;                 % number of escalators to install
var min_elevators..max_elevators: num_elevators;       % number of elevators to install
var 0..(max_escalators*escalator_space + max_elevators*elevator_space): total_space;

% Constraints

% Capacity constraint: total people-per-minute transported must meet requirement
constraint
  escalator_capacity * num_escalators + elevator_capacity * num_elevators
  >= min_total_capacity;

% Ratio constraint: at least escalator_ratio times more escalators than elevators
constraint
  num_escalators >= escalator_ratio * num_elevators;

% Space accounting: total_space equals space used by installed escalators and elevators
constraint
  total_space =
    escalator_space * num_escalators + elevator_space * num_elevators;

% Objective
solve minimize total_space;