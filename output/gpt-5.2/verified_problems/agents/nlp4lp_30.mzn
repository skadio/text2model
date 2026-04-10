% Parameters
int: K; % number of departments
int: L; % number of possible locations (including London if modeled as a location)

set of int: DEPTS = 1..K; % department index set
set of int: LOCS  = 1..L; % location index set

array[DEPTS, LOCS] of int: Benefit; % benefit (in thousands of pounds) for dept k at location l
array[DEPTS, DEPTS] of float: Communication; % quantity of communication between departments k and j
array[LOCS, LOCS] of int: Cost; % unit communication cost between locations l and m


% Variables
array[DEPTS] of var LOCS: loc_of_dept; % assigned location for each department

array[DEPTS, LOCS] of var 0..1: assign; % assign[k,l] = 1 iff department k is located at location l

var int: total_benefit;     % total benefit from relocations (thousands of pounds)
var float: total_comm_cost; % total communication cost
var float: total_cost;      % overall yearly cost = communication cost - benefit (minimize)


% Constraints

% --- Link location decision to assignment matrix ---
constraint
  forall(k in DEPTS) (
    sum(l in LOCS)(assign[k,l]) = 1
  );

constraint
  forall(k in DEPTS, l in LOCS) (
    assign[k,l] = bool2int(loc_of_dept[k] = l)
  );

% --- Capacity: no location may host more than three departments ---
constraint
  forall(l in LOCS) (
    sum(k in DEPTS)(assign[k,l]) <= 3
  );

% --- Compute total benefit from assignments ---
constraint
  total_benefit =
    sum(k in DEPTS, l in LOCS)(Benefit[k,l] * assign[k,l]);

% --- Compute total communication cost induced by department locations ---
% Communication cost between depts k and j is Communication[k,j] * Cost[loc(k), loc(j)]
constraint
  total_comm_cost =
    sum(k in DEPTS, j in DEPTS)(
      Communication[k,j] * int2float(Cost[loc_of_dept[k], loc_of_dept[j]])
    );

% --- Combine into overall yearly cost (communication cost - benefit) ---
constraint
  total_cost = total_comm_cost - int2float(total_benefit);


% Objective
solve minimize total_cost;