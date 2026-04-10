% Parameters (with values embedded)
int: pigeon_capacity = 2;
int: owl_capacity = 5;
int: pigeon_treats = 3;
int: owl_treats = 5;

int: treat_budget = 1000;
int: min_pigeons = 20;

% At most 40% of the birds can be owls: owls <= 0.4*(owls+pigeons)
% Use integer form: 5*owls <= 2*(owls+pigeons)  <=> 3*owls <= 2*pigeons
int: owl_ratio_num_lhs = 3;  % 3*owls
int: owl_ratio_num_rhs = 2;  % 2*pigeons

% Variables
var 0..(treat_budget div pigeon_treats): pigeons;
var 0..(treat_budget div owl_treats): owls;

% Constraints
constraint pigeons >= min_pigeons;

constraint pigeon_treats * pigeons + owl_treats * owls <= treat_budget;

% Owl proportion constraint (at most 40% owls)
constraint owl_ratio_num_lhs * owls <= owl_ratio_num_rhs * pigeons;

% Objective
var 0..(pigeon_capacity * (treat_budget div pigeon_treats)
      + owl_capacity * (treat_budget div owl_treats)): total_letters;
constraint total_letters = pigeon_capacity * pigeons + owl_capacity * owls;

solve maximize total_letters;