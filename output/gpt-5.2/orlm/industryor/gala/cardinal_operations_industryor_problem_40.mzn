% Investment planning over 3 years (no borrowing), maximize wealth at end of Year 3.

include "globals.mzn";

% ---------- Data (embedded) ----------
int: initial_capital = 500000;

% Interest multipliers
float: r1 = 1.20; % 1-year product (Years 1-3), unlimited
float: r2 = 1.50; % 2-year product (start Y1 -> end Y2), cap 120k
float: r3 = 1.60; % same-year product in Y2 (start Y2 -> end Y2), cap 150k
float: r4 = 1.40; % 1-year product in Y3 (start Y3 -> end Y3), cap 100k

% Caps
int: cap2 = 120000;
int: cap3 = 150000;
int: cap4 = 100000;

% Scale to avoid floating point: represent money in yuan, but multipliers as integers / 100.
int: SCALE = 100;
int: R1 = 120;
int: R2 = 150;
int: R3 = 160;
int: R4 = 140;

% ---------- Decision variables (all in yuan) ----------
% Year 1 allocations
var 0..initial_capital: x11;          % invest in 1-year product at start of Y1
var 0..cap2:           x12;          % invest in 2-year product at start of Y1

% Year 2 allocations (at start of Y2, using wealth from end of Y1)
var 0..initial_capital*2: x21;       % invest in 1-year product at start of Y2
var 0..cap3:              x23;       % invest in same-year product at start of Y2

% Year 3 allocations (at start of Y3, using wealth from end of Y2)
var 0..initial_capital*5: x31;       % invest in 1-year product at start of Y3
var 0..cap4:              x34;       % invest in capped 1-year product at start of Y3

% Cash/wealth at decision points (in yuan)
var 0..initial_capital*5: w1_end;    % end of Year 1 (available at start of Y2)
var 0..initial_capital*5: w2_end;    % end of Year 2 (available at start of Y3)
var 0..initial_capital*10: w3_end;   % end of Year 3 (objective)

% ---------- Constraints ----------
% Year 1 budget (no borrowing)
constraint x11 + x12 <= initial_capital;

% End of Year 1 wealth: proceeds from Y1 1-year product + uninvested cash
% w1_end = 1.20*x11 + (initial_capital - x11 - x12)
constraint w1_end * SCALE =
    R1 * x11 + SCALE * (initial_capital - x11 - x12);

% Year 2 budget (no borrowing)
constraint x21 + x23 <= w1_end;

% End of Year 2 wealth includes:
% - proceeds from Y2 1-year product: 1.20*x21
% - proceeds from Y1 2-year product: 1.50*x12
% - proceeds from Y2 same-year product: 1.60*x23
% - plus any uninvested cash carried through year: (w1_end - x21 - x23)
constraint w2_end * SCALE =
    R1 * x21 + R2 * x12 + R3 * x23 + SCALE * (w1_end - x21 - x23);

% Year 3 budget (no borrowing)
constraint x31 + x34 <= w2_end;

% End of Year 3 wealth includes:
% - proceeds from Y3 1-year product (unlimited): 1.20*x31
% - proceeds from Y3 capped product: 1.40*x34
% - plus any uninvested cash: (w2_end - x31 - x34)
constraint w3_end * SCALE =
    R1 * x31 + R4 * x34 + SCALE * (w2_end - x31 - x34);

% ---------- Objective ----------
solve maximize w3_end;

% ---------- Output ----------
output [
  "Optimal end-of-Year-3 wealth (yuan) = ", show(w3_end), "\n",
  "Decisions (yuan):\n",
  "  Year1: x11(1yr@1.20) = ", show(x11), ", x12(2yr@1.50,cap120k) = ", show(x12), "\n",
  "  End Y1 wealth = ", show(w1_end), "\n",
  "  Year2: x21(1yr@1.20) = ", show(x21), ", x23(Y2 same-year@1.60,cap150k) = ", show(x23), "\n",
  "  End Y2 wealth = ", show(w2_end), "\n",
  "  Year3: x31(1yr@1.20) = ", show(x31), ", x34(1yr@1.40,cap100k) = ", show(x34), "\n"
];