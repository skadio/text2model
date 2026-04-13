% Parameters
int: budget = 1000;              % Maximum total allocation allowed
int: costX  = 20;                % Cost coefficient for project X
int: costY  = 30;                % Cost coefficient for project Y
int: costZ  = 40;                % Cost coefficient for project Z

int: rhs_diff1 = 300;            % RHS for constraint: 2*x - y + z >= 300
int: rhs_eq    = 200;            % RHS for constraint: x - 3*y - z = 200


% Variables
var 0..budget: x;                % Allocation to project X (integer units)
var 0..budget: y;                % Allocation to project Y (integer units)
var 0..budget: z;                % Allocation to project Z (integer units)

% Upper bound: if x=y=z=budget, total_cost <= (20+30+40)*budget = 90000
var 0..((costX + costY + costZ) * budget): total_cost;


% Constraints
% Budget constraint: total allocation across projects must not exceed budget
constraint x + y + z <= budget;

% Difference constraint: 2*x - y + z must be at least rhs_diff1
constraint 2*x - y + z >= rhs_diff1;

% Equality constraint: x - 3*y - z must equal rhs_eq exactly
constraint x - 3*y - z = rhs_eq;

% Total cost definition
constraint total_cost = costX*x + costY*y + costZ*z;


% Objective
solve minimize total_cost;