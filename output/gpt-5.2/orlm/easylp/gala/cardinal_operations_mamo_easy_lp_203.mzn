include "globals.mzn";

/* Data (embedded) */
int: TOTAL = 1000000;

int: minX = 200000;
int: minY = 150000;
int: minZ = 250000;

/* Returns in basis points (1 bp = 0.01%) to keep everything integer:
   2% = 200 bp, 3% = 300 bp, 4% = 400 bp
*/
int: rX_bp = 200;
int: rY_bp = 300;
int: rZ_bp = 400;

/* Decision variables: whole-dollar investments */
var minX..TOTAL: x;
var minY..TOTAL: y;
var minZ..TOTAL: z;

/* Constraints */
constraint x + y + z = TOTAL;

/* Objective: minimize total return in basis points of dollars (i.e., dollar*bp) */
var 0..TOTAL * 400: total_return_dollars;
constraint total_return_dollars * 10000 = x * rX_bp + y * rY_bp + z * rZ_bp;

solve minimize total_return_dollars;

/* Output (rounded to nearest dollar; it's already integral dollars) */
output [
  "x = $", show(x), "\n",
  "y = $", show(y), "\n",
  "z = $", show(z), "\n",
  "Minimum total return (rounded to nearest dollar) = $", show(total_return_dollars), "\n"
];