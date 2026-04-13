int: MAX_TOTAL = 50;
int: MIN_YZ = 30;
int: MAX_XZ = 40;

int: scoreX = 3;
int: scoreY = 4;
int: scoreZ = 2;

var 0..MAX_TOTAL: x;
var 0..MAX_TOTAL: y;
var 0..MAX_TOTAL: z;

constraint x + y + z <= MAX_TOTAL;
constraint y + z >= MIN_YZ;
constraint x + z <= MAX_XZ;

var int: totalScore = scoreX * x + scoreY * y + scoreZ * z;

solve minimize totalScore;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_total_score=", show(totalScore), "\n"
];