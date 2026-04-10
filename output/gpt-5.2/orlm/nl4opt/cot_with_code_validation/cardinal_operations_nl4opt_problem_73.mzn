% Parameters
int: budget = 100000;
int: telecom_max = 70000;
int: telecom_min_ratio = 3; % telecom >= 3 * healthcare

int: r_telecom = 3;   % percent
int: r_health = 1;    % percent

% Variables
var 0..budget: telecom;
var 0..budget: health;

% Constraints
constraint telecom + health <= budget;
constraint telecom >= telecom_min_ratio * health;
constraint telecom <= telecom_max;

% Objective
var 0..(r_telecom*budget + r_health*budget): profit_units; % profit * 100 in dollars
constraint profit_units = r_telecom * telecom + r_health * health;

solve maximize profit_units;