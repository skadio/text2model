% Parameters
int: scale = 10;

int: leg1 = 5;     % 0.5 * scale
int: back1 = 8;    % 0.8 * scale
int: sleep1 = 3;   % 0.3 * scale

int: leg2 = 7;     % 0.7 * scale
int: back2 = 4;    % 0.4 * scale
int: sleep2 = 6;   % 0.6 * scale

int: max_sleep = 80;  % 8.0 * scale
int: min_legs  = 40;  % 4.0 * scale

int: max_dose = 26; % safe upper bound from sleep constraint: max(80/3, 80/6) -> 26

% Variables
var 0..max_dose: x1; % doses of pain killer 1
var 0..max_dose: x2; % doses of pain killer 2

var 0..(back1*max_dose + back2*max_dose): back_total;

% Constraints
constraint sleep1*x1 + sleep2*x2 <= max_sleep;

constraint leg1*x1 + leg2*x2 >= min_legs;

constraint back_total = back1*x1 + back2*x2;

% Objective
solve maximize back_total;