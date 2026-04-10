% Coin plating optimization (all data embedded)

int: gold_available = 500;
int: wires_available = 300;

int: gold_A = 3;
int: wires_A = 2;
int: coins_A = 5;

int: gold_B = 5;
int: wires_B = 3;
int: coins_B = 7;

% Upper bounds from resource limits
int: maxA = min(gold_available div gold_A, wires_available div wires_A);
int: maxB = min(gold_available div gold_B, wires_available div wires_B);

var 0..maxA: A;
var 0..maxB: B;

constraint gold_A * A + gold_B * B <= gold_available;
constraint wires_A * A + wires_B * B <= wires_available;

var int: total_coins = coins_A * A + coins_B * B;

solve maximize total_coins;

output [
  "A=", show(A), "\n",
  "B=", show(B), "\n",
  "TotalCoins=", show(total_coins), "\n",
  "GoldUsed=", show(gold_A*A + gold_B*B), " / ", show(gold_available), "\n",
  "WiresUsed=", show(wires_A*A + wires_B*B), " / ", show(wires_available), "\n"
];