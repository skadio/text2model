% Diet optimization: minimize unsaturated fat intake

int: vitA_req = 80;
int: vitC_req = 100;

int: vitA_crab = 5;
int: vitC_crab = 7;
int: fat_crab  = 4;

int: vitA_lob  = 8;
int: vitC_lob  = 4;
int: fat_lob   = 6;

% Decision variables: number of meals of each type
var 0..200: crab;
var 0..200: lobster;

constraint vitA_crab * crab + vitA_lob * lobster >= vitA_req;
constraint vitC_crab * crab + vitC_lob * lobster >= vitC_req;

% At most 40% lobster rolls: lobster / (crab + lobster) <= 0.4
% Equivalent: 5*lobster <= 2*(crab + lobster) -> 3*lobster <= 2*crab
constraint 3 * lobster <= 2 * crab;

var int: total_fat = fat_crab * crab + fat_lob * lobster;

solve minimize total_fat;

output [
  "crab=", show(crab), "\n",
  "lobster=", show(lobster), "\n",
  "total_fat=", show(total_fat), "\n"
];