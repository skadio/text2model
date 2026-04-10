% Linear programming model (integer decision variables) for the production problem.
% Data are embedded directly as requested.

include "globals.mzn";

%--------------------%
% Parameters (data)  %
%--------------------%
int: t1A = 2;  int: t2A = 3;          % hours per unit of A in process 1 and 2
int: t1B = 3;  int: t2B = 4;          % hours per unit of B in process 1 and 2
int: cap1 = 16; int: cap2 = 24;       % available hours in process 1 and 2

int: c_per_B = 2;                     % by-product C generated per unit of B
int: c_sell_cap = 5;                  % max units of C that can be sold
int: c_dispose_cost = 2;              % cost per unit of C disposed

int: profitA = 4;
int: profitB = 10;
int: profitC = 3;

%--------------------%
% Decision variables %
%--------------------%
var 0..1000: A;                       % units of product A produced/sold
var 0..1000: B;                       % units of product B produced/sold
var 0..1000: C_sold;                  % units of by-product C sold
var 0..1000: C_disposed;              % units of by-product C disposed

%--------------------%
% Constraints        %
%--------------------%
% Process capacity constraints
constraint t1A*A + t1B*B <= cap1;
constraint t2A*A + t2B*B <= cap2;

% By-product flow balance
constraint C_sold + C_disposed = c_per_B * B;

% Sales limit for C
constraint C_sold <= c_sell_cap;

%--------------------%
% Objective          %
%--------------------%
var int: total_profit =
    profitA * A
  + profitB * B
  + profitC * C_sold
  - c_dispose_cost * C_disposed;

solve maximize total_profit;

%--------------------%
% Output             %
%--------------------%
output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "C_sold = ", show(C_sold), "\n",
  "C_disposed = ", show(C_disposed), "\n",
  "Total profit = ", show(total_profit), "\n"
];