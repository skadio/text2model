% Flooring production optimization (all data embedded)

% Decision variables (square feet produced weekly)
var 0..40000: laminate;   % engineered laminate planks
var 0..20000: carpet;     % carpets

% Demand minimums
constraint laminate >= 15000;
constraint carpet   >= 5000;

% Shipping requirement: total production at least 50,000 sq ft
constraint laminate + carpet >= 50000;

% Profit (use cents to keep integers: $2.1 -> 210 cents, $3.3 -> 330 cents)
var int: profit_cents = 210 * laminate + 330 * carpet;

solve maximize profit_cents;

output [
  "Laminate (sq ft) = ", show(laminate), "\n",
  "Carpet   (sq ft) = ", show(carpet), "\n",
  "Total    (sq ft) = ", show(laminate + carpet), "\n",
  "Profit ($)        = ", show(profit_cents div 100), ".", 
                         if profit_cents mod 100 < 10 then "0" else "" endif,
                         show(profit_cents mod 100), "\n"
];