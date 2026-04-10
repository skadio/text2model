% Parameters
% Fatigue cost per hour for each training group
int: c1 = 10;  % group x1 (skill development)
int: c2 = 15;  % group x2 (strength conditioning)
int: c3 = 12;  % group x3 (strategy training)
int: c4 = 20;  % group x4 (recovery sessions)

% Constraint limits / requirements
int: max_x1_x2 = 8;    % x1 + x2 <= 8
int: max_x3_x4 = 10;   % x3 + x4 <= 10
int: min_x1_x3 = 5;    % x1 + x3 >= 5
int: min_x2_x4 = 6;    % x2 + x4 >= 6

% NOTE: The problem mentions "specific bounds" per group but provides no numbers.
% We therefore assume non-negative hours and conservative upper bounds implied by pairwise maxima.
int: x1_lb = 0;
int: x2_lb = 0;
int: x3_lb = 0;
int: x4_lb = 0;

int: x1_ub = max_x1_x2;  % since x1 + x2 <= 8
int: x2_ub = max_x1_x2;
int: x3_ub = max_x3_x4;  % since x3 + x4 <= 10
int: x4_ub = max_x3_x4;


% Variables
var x1_lb..x1_ub: x1;  % weekly hours for group x1 (integer hours)
var x2_lb..x2_ub: x2;  % weekly hours for group x2 (integer hours)
var x3_lb..x3_ub: x3;  % weekly hours for group x3 (integer hours)
var x4_lb..x4_ub: x4;  % weekly hours for group x4 (integer hours)

var int: total_fatigue; % total fatigue score (objective value)


% Constraints
% Pairwise schedule limit constraints (upper bounds on combined hours)
constraint x1 + x2 <= max_x1_x2;  % skill + strength <= 8
constraint x3 + x4 <= max_x3_x4;  % strategy + recovery <= 10

% Balance / minimum training requirements (lower bounds on combined hours)
constraint x1 + x3 >= min_x1_x3;  % skill + strategy >= 5
constraint x2 + x4 >= min_x2_x4;  % strength + recovery >= 6

% Fatigue score definition
constraint total_fatigue = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_fatigue;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum total_fatigue=", show(total_fatigue), "\n"
];