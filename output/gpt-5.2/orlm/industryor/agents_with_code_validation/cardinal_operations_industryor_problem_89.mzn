% Parameters
int: total_shirts = 200;                 % Total shirts available to clear
int: total_pants  = 100;                 % Total pairs of pants available to clear

int: price_A = 30;                       % Price (£) per Package A
int: price_B = 50;                       % Price (£) per Package B

int: shirts_in_A = 1;                    % Shirts used per Package A
int: pants_in_A  = 2;                    % Pants used per Package A

int: shirts_in_B = 3;                    % Shirts used per Package B
int: pants_in_B  = 1;                    % Pants used per Package B

int: min_A = 20;                         % Minimum number of A packages to sell
int: min_B = 10;                         % Minimum number of B packages to sell

% Variables
var min_A..total_shirts: num_A;          % Number of A packages sold
var min_B..total_shirts: num_B;          % Number of B packages sold

var 0..(price_A*total_shirts + price_B*total_shirts): revenue;  % Total revenue (£)

% Constraints
% Inventory constraints: cannot exceed available shirts and pants
constraint
  shirts_in_A * num_A + shirts_in_B * num_B <= total_shirts;

constraint
  pants_in_A * num_A + pants_in_B * num_B <= total_pants;

% Revenue definition: link decision variables to total revenue
constraint
  revenue = price_A * num_A + price_B * num_B;

% Objective
solve maximize revenue;