% Amusement park games optimization (all data embedded)

% Data
int: cust_throw = 15;
int: cust_climb = 8;

int: cost_throw = 2;   % $/hour prizes
int: cost_climb = 3;

int: budget = 100;     % $/hour max prizes

% Decision variables
var 0..(budget div cost_throw): throwing;   % maximum possible within budget
var 0..(budget div cost_climb): climbing;

% Constraints
constraint cost_throw * throwing + cost_climb * climbing <= budget;
constraint throwing >= 2 * climbing;        % at least twice as many throwing
constraint climbing >= 5;                   % at least 5 climbing games

% Objective: maximize customers per hour
var int: total_customers = cust_throw * throwing + cust_climb * climbing;

solve maximize total_customers;

output [
  "throwing = ", show(throwing), "\n",
  "climbing = ", show(climbing), "\n",
  "total_customers_per_hour = ", show(total_customers), "\n",
  "prize_cost_per_hour = ", show(cost_throw*throwing + cost_climb*climbing), "\n"
];