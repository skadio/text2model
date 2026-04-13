include "globals.mzn";

/* Data (embedded from problem statement) */
int: vitA_req = 80;
int: vitC_req = 100;

int: vitA_crab = 5;
int: vitC_crab = 7;
int: fat_crab  = 4;

int: vitA_lob  = 8;
int: vitC_lob  = 4;
int: fat_lob   = 6;

/* Decision variables: number of meals of each type */
var 0..1000: crab;
var 0..1000: lobster;

/* Use the hint's meal-count modeling (choose n large enough to cover optimum) */
int: n = 100;
array[1..n] of var 0..1: meal;  % 0=crab, 1=lobster

constraint count(meal, 0, crab);
constraint count(meal, 1, lobster);

/* Nutrition constraints */
constraint vitA_crab * crab + vitA_lob * lobster >= vitA_req;
constraint vitC_crab * crab + vitC_lob * lobster >= vitC_req;

/* At most 40% of meals are lobster:
   lobster <= 0.4*(crab+lobster)  <=>  5*lobster <= 2*(crab+lobster)  <=>  3*lobster <= 2*crab
*/
constraint 3 * lobster <= 2 * crab;

/* Objective: minimize unsaturated fat */
var 0..1000000: total_fat = fat_crab * crab + fat_lob * lobster;

solve minimize total_fat;

output [
  "crab = ", show(crab), "\n",
  "lobster = ", show(lobster), "\n",
  "total_meals = ", show(crab + lobster), "\n",
  "total_fat = ", show(total_fat), "\n"
];