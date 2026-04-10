% Parameters
int: vitA_req = 80;
int: vitC_req = 100;

int: vitA_crab = 5;
int: vitC_crab = 7;
int: vitA_lob = 8;
int: vitC_lob = 4;

int: fat_crab = 4;
int: fat_lob = 6;

% Variables
var 0..1000: crab;
var 0..1000: lobster;

% Constraints
constraint vitA_crab * crab + vitA_lob * lobster >= vitA_req;
constraint vitC_crab * crab + vitC_lob * lobster >= vitC_req;

% At most 40% lobster: lobster <= 0.4*(crab+lobster)  <=>  3*lobster <= 2*crab
constraint 3 * lobster <= 2 * crab;

% Objective
solve minimize fat_crab * crab + fat_lob * lobster;