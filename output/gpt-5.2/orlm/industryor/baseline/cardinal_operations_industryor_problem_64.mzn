% Monthly production plan for microwave ovens and water heaters
% All data embedded

% Decision variables: quantities produced/sold per month
var int: x; % microwave ovens
var int: y; % water heaters

% Overtime hours in workshop A (allowed up to 20)
var 0..20: otA;

% Parameters
int: A_avail = 250;
int: B_avail = 150;

int: A_cost = 80;  % yuan per hour
int: B_cost = 20;  % yuan per hour

int: insp_mw = 30; % yuan per unit
int: insp_wh = 50; % yuan per unit
int: insp_budget = 5500;

% Processing/assembly hours per unit
int: A_mw = 2; int: B_mw = 1;
int: A_wh = 1; int: B_wh = 3;

% Sales estimates / minimum sales requirements
int: mw_min = 80;
int: wh_min = 50;

% Nonnegativity (and reasonable upper bounds to help the solver)
constraint x >= 0 /\ y >= 0;

% Constraints
% 1. Inspection and sales costs budget
constraint insp_mw * x + insp_wh * y <= insp_budget;

% 2. At least 80 microwave ovens sold/produced
constraint x >= mw_min;

% 5. At least 50 water heaters sold/produced
constraint y >= wh_min;

% 3. Workshop hours fully utilized
%    Workshop B: exactly use all available hours
constraint B_mw * x + B_wh * y = B_avail;

%    Workshop A: use all available hours plus overtime
constraint A_mw * x + A_wh * y = A_avail + otA;

% 4. Overtime in workshop A limited (already by domain 0..20)
constraint otA <= 20;

% Objective: minimize total workshop labor cost (regular + overtime)
var int: total_cost = A_cost * (A_avail + otA) + B_cost * B_avail;
solve minimize total_cost;

output [
  "Microwave ovens (x) = ", show(x), "\n",
  "Water heaters (y)   = ", show(y), "\n",
  "Overtime in A (h)   = ", show(otA), "\n",
  "Inspection+sales cost = ", show(insp_mw*x + insp_wh*y), " yuan\n",
  "Workshop A hours used = ", show(A_mw*x + A_wh*y), " (avail ", show(A_avail), " + ot ", show(otA), ")\n",
  "Workshop B hours used = ", show(B_mw*x + B_wh*y), " (avail ", show(B_avail), ")\n",
  "Total labor cost = ", show(total_cost), " yuan\n"
];