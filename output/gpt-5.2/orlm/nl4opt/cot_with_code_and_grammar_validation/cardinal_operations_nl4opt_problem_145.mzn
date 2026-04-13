% Parameters
int: vitA_min = 80;
int: vitC_min = 100;

int: vitA_crab = 5;
int: vitC_crab = 7;
int: fat_crab  = 4;

int: vitA_lob  = 8;
int: vitC_lob  = 4;
int: fat_lob   = 6;

int: max_lob_pct = 40; % percent

% Variables
var 0..1000: crab;
var 0..1000: lob;

% Constraints
constraint vitA_crab * crab + vitA_lob * lob >= vitA_min;
constraint vitC_crab * crab + vitC_lob * lob >= vitC_min;

% At most 40% lobster: lob <= 0.4*(crab+lob)  <=>  3*lob <= 2*crab
constraint 3 * lob <= 2 * crab;

% Objective
solve minimize fat_crab * crab + fat_lob * lob;