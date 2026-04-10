% Parameters
int: total_shirts = 200;              % Total shirts available to clear
int: total_pants  = 100;              % Total pairs of pants available to clear

int: price_A = 30;                    % Revenue (£) per Package A
int: price_B = 50;                    % Revenue (£) per Package B

int: shirts_in_A = 1;                 % Shirts used in one Package A
int: pants_in_A  = 2;                 % Pants used in one Package A

int: shirts_in_B = 3;                 % Shirts used in one Package B
int: pants_in_B  = 1;                 % Pants used in one Package B

int: min_A = 20;                      % Minimum number of A packages to sell
int: min_B = 10;                      % Minimum number of B packages to sell

% Upper bounds derived from inventory (used to bound decision variables)
int: max_A = total_pants div pants_in_A;     % A limited by pants: 100 div 2 = 50
int: max_B = total_shirts div shirts_in_B;   % B limited by shirts: 200 div 3 = 66

% Variables
var min_A..max_A: num_A;               % Number of Package A to sell
var min_B..max_B: num_B;               % Number of Package B to sell

var 0..total_shirts: shirts_used;      % Total shirts used by sold packages
var 0..total_pants:  pants_used;       % Total pants used by sold packages

var 0..(price_A * max_A + price_B * max_B): revenue;  % Total revenue (£)

% Constraints

% Inventory usage definitions (link decision vars to resource usage totals)
constraint
  shirts_used = shirts_in_A * num_A + shirts_in_B * num_B;

constraint
  pants_used  = pants_in_A  * num_A + pants_in_B  * num_B;

% Inventory capacity constraints (cannot use more than available stock)
constraint
  shirts_used <= total_shirts;

constraint
  pants_used  <= total_pants;

% Revenue definition (link decision vars to total revenue)
constraint
  revenue = price_A * num_A + price_B * num_B;

% Objective
solve maximize revenue;