% Parameters
int: total_mrna = 20000;
int: mrna_child = 50;
int: mrna_adult = 75;
int: fever_child = 50;
int: fever_adult = 75;
int: min_child = 50;

% Variables
var 0..(total_mrna div mrna_child): x_child;
var 0..(total_mrna div mrna_adult): x_adult;

% Constraints
constraint mrna_child * x_child + mrna_adult * x_adult <= total_mrna;

constraint x_child >= min_child;

% at least 70% adult: x_adult / (x_child + x_adult) >= 0.7
% => 10*x_adult >= 7*(x_child + x_adult) => 3*x_adult >= 7*x_child
constraint 3 * x_adult >= 7 * x_child;

% Objective
var 0..(fever_child * (total_mrna div mrna_child) + fever_adult * (total_mrna div mrna_adult)): total_fever;
constraint total_fever = fever_child * x_child + fever_adult * x_adult;

solve minimize total_fever;