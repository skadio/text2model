% Parameters
int: total_mrna = 20000;
int: mrna_child = 50;
int: fever_child = 50;
int: mrna_adult = 75;
int: fever_adult = 75;
int: min_child = 50;
int: adult_pct = 70; % percent
int: pct_base = 100;

% Variables
var 0..(total_mrna div mrna_child): x_child;
var 0..(total_mrna div mrna_adult): x_adult;

% Constraints
constraint mrna_child * x_child + mrna_adult * x_adult <= total_mrna;

constraint x_child >= min_child;

% At least 70% of vaccines are adult:
% x_adult / (x_child + x_adult) >= 0.70  <=>  100*x_adult >= 70*(x_child+x_adult)
constraint pct_base * x_adult >= adult_pct * (x_child + x_adult);

% Objective
solve minimize fever_child * x_child + fever_adult * x_adult;