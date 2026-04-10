% Parameters
int: total_mrna = 20000;

int: mrna_child = 50;
int: fever_child = 50;

int: mrna_adult = 75;
int: fever_adult = 75;

int: min_child = 50;
int: adult_pct_num = 70;
int: adult_pct_den = 100;

% Variables
var 0..(total_mrna div mrna_child): n_child;
var 0..(total_mrna div mrna_adult): n_adult;

% Constraints
constraint mrna_child * n_child + mrna_adult * n_adult <= total_mrna;

constraint n_child >= min_child;

% At least 70% of vaccines are adult:
% n_adult / (n_child + n_adult) >= 0.70  <=>  100*n_adult >= 70*(n_child+n_adult)
constraint adult_pct_den * n_adult >= adult_pct_num * (n_child + n_adult);

% Objective
solve minimize fever_child * n_child + fever_adult * n_adult;