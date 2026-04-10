% Parameters
int: allergy_req = 700;
int: fever_req = 600;
int: compound_avail = 1000;

int: a1 = 20;  % allergy pills per hour in factory 1
int: f1 = 15;  % fever pills per hour in factory 1
int: c1 = 20;  % compound units per hour in factory 1

int: a2 = 10;  % allergy pills per hour in factory 2
int: f2 = 30;  % fever pills per hour in factory 2
int: c2 = 30;  % compound units per hour in factory 2

% Variables
var 0..compound_avail: h1;  % hours to run factory 1
var 0..compound_avail: h2;  % hours to run factory 2

% Constraints
constraint a1 * h1 + a2 * h2 >= allergy_req;
constraint f1 * h1 + f2 * h2 >= fever_req;
constraint c1 * h1 + c2 * h2 <= compound_avail;

% Objective
solve minimize h1 + h2;