% Real estate project allocation - embedded data

int: max_projects = 50;

int: min_res = 10;
int: min_com = 15;
int: min_ind = 5;

int: cost_res = 10000;
int: cost_com = 8000;
int: cost_ind = 6000;

var int: X; % Residential
var int: Y; % Commercial
var int: Z; % Industrial

constraint X >= min_res;
constraint Y >= min_com;
constraint Z >= min_ind;

constraint X + Y + Z <= max_projects;

% Balanced portfolio constraint: 2X - Y + Z >= 20
constraint 2*X - Y + Z >= 20;

var int: total_cost = cost_res*X + cost_com*Y + cost_ind*Z;

solve minimize total_cost;

output [
  "Residential X = ", show(X), "\n",
  "Commercial  Y = ", show(Y), "\n",
  "Industrial  Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];