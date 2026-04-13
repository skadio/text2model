% Parameters
int: cost1 = 5;   % cost per unit for Project 1
int: cost2 = 7;   % cost per unit for Project 2
int: cost3 = 3;   % cost per unit for Project 3
int: cost4 = 8;   % cost per unit for Project 4

int: limit12 = 1500;     % x1 + 2*x2 <= 1500
int: threshold13 = 1000; % 3*x1 + x3 >= 1000
int: limit42 = 600;      % 4*x4 - x2 <= 600
int: deficit = 200;      % x1 - x2 - x3 - x4 = 200

int: ub1 = 500; % upper bound for x1
int: ub2 = 400; % upper bound for x2
int: ub3 = 300; % upper bound for x3
int: ub4 = 200; % upper bound for x4

% Variables
var 0..ub1: x1;           % integer units allocated to Project 1
var 0..ub2: x2;           % integer units allocated to Project 2
var 0..ub3: x3;           % integer units allocated to Project 3
var 0..ub4: x4;           % integer units allocated to Project 4
var int: total_cost;      % total cost (in dollars)

% Constraints
% Linear resource/budget constraints
constraint x1 + 2 * x2 <= limit12;       % Project 1 plus twice Project 2 within limit
constraint 3 * x1 + x3 >= threshold13;   % Thrice Project 1 plus Project 3 meets threshold
constraint 4 * x4 - x2 <= limit42;       % Four times Project 4 relative to Project 2 within limit

% Inter-dependency / balance constraint across projects
constraint x1 - x2 - x3 - x4 = deficit;  % Net deficit relationship among allocations

% Total cost definition
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Objective
solve minimize total_cost;