# Sets
T = {1, …, n}
P = {1, …, m}
M = {1, …, k}

# Parameters
d[t,p]          # demand
c[t,p]          # unit production cost
h[p]            # unit holding cost
a[t,p,m]        # machine‑hour requirement
cap[t,m]        # machine capacity
I0[p]           # initial inventory
minProd[t,p]    # optional minimum production (0 if none)

# Variables
x[t,p] >= 0 integer   # production
I[t,p] >= 0 integer   # ending inventory

# Objective: maximise total profit
maximise
    sum_{t∈T} sum_{p∈P} ( (p_sell[p] - c[t,p]) * x[t,p] - h[p] * I[t,p] )

# Constraints
# 1. Production capacity
forall t∈T, m∈M:
    sum_{p∈P} a[t,p,m] * x[t,p] <= cap[t,m]

# 2. Inventory balance
forall t∈T, p∈P:
    I[t,p] = I[t-1,p] + x[t,p] - d[t,p]
# initial inventory
forall p∈P:
    I[0,p] = I0[p]

# 3. Non‑negativity (already in variable definition)

# 4. Minimum production (if required)
forall t∈T, p∈P:
    x[t,p] >= minProd[t,p]