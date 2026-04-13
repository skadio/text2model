% Parameters (with values embedded)
int: total_mrna = 20000;
int: mrna_child = 50;
int: fever_child = 50;
int: mrna_adult = 75;
int: fever_adult = 75;
int: min_children = 50;

% Variables
var 0..(total_mrna div mrna_child): child;
var 0..(total_mrna div mrna_adult): adult;

% Constraints
constraint mrna_child * child + mrna_adult * adult <= total_mrna;
constraint child >= min_children;

% At least 70% of vaccines should be adult: adult / (adult + child) >= 0.7
% Equivalent linear form: 10*adult >= 7*(adult + child) -> 3*adult >= 7*child
constraint 3 * adult >= 7 * child;

% Objective
var 0..(fever_child * (total_mrna div mrna_child) + fever_adult * (total_mrna div mrna_adult)): total_fever;
constraint total_fever = fever_child * child + fever_adult * adult;

solve minimize total_fever;