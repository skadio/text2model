% Parameters (with values embedded)
int: n = 4;
set of int: G = 1..n;

int: CO2 = 1;
int: CH4 = 2;
int: N2O = 3;
int: CFC = 4;

array[G] of int: gwp = [4, 3, 5, 7];

int: rhs1 = 1000;
int: rhs2 = 800;
int: rhs3 = 200;
int: rhs4 = 1500;

% Variables
array[G] of var 0..rhs4: x; % emissions (tons), integer and non-negative

% Constraints
constraint x[CO2] + x[CH4] - 2*x[N2O] - 2*x[CFC] <= rhs1;
constraint 3*x[CO2] - x[CH4] + x[N2O] <= rhs2;
constraint x[CO2] - x[CH4] - x[N2O] >= rhs3;
constraint sum(g in G)(x[g]) <= rhs4;

% Objective
solve minimize sum(g in G)(gwp[g] * x[g]);