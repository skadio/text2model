% Vaccine production optimization
% Minimize fever suppressant usage subject to mRNA availability and mix constraints.

int: total_mrna = 20000;          % mg available

int: mrna_child = 50;            % mg per children's vaccine
int: fever_child = 50;           % mg per children's vaccine

int: mrna_adult = 75;            % mg per adult vaccine
int: fever_adult = 75;           % mg per adult vaccine

int: min_children = 50;          % at least 50 children's vaccines
int: adult_ratio_percent = 70;   % at least 70% adult

var 0..(total_mrna div mrna_child): c;  % number of children's vaccines
var 0..(total_mrna div mrna_adult): a;  % number of adult vaccines

constraint c >= min_children;

% mRNA availability
constraint mrna_child * c + mrna_adult * a <= total_mrna;

% Adult vaccines are at least 70% of total: a / (a+c) >= 0.70
% Linearized: 100*a >= 70*(a+c)  => 30*a >= 70*c
constraint 30 * a >= 70 * c;

% Objective: minimize fever suppressant used
var int: total_fever = fever_child * c + fever_adult * a;
solve minimize total_fever;

output [
  "children_vaccines=", show(c), "\n",
  "adult_vaccines=", show(a), "\n",
  "total_vaccines=", show(a + c), "\n",
  "fever_suppressant_used_mg=", show(total_fever), "\n",
  "mrna_used_mg=", show(mrna_child * c + mrna_adult * a), "\n"
];