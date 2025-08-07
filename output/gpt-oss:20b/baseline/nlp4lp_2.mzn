**Answer**

The problem is **NP‑hard**.  
In fact, the decision version

> “Does the graph contain a clique of size at least k that is a
>  dominating set?”  

is NP‑complete, and the optimisation problem of finding the largest
such clique is NP‑hard.

---

### 1.  The decision problem is NP‑complete

Let  

\[
\text{CLIQUE‑DOM}=\{(G,k)\mid G\text{ has a dominating clique of size }\ge k\}.
\]

*Membership in NP.*  
Given a set \(C\subseteq V(G)\) we can in polynomial time check that
\(C\) is a clique and that every vertex of \(G\) is either in \(C\) or
adjacent to a vertex of \(C\).  Hence a certificate can be verified
in polynomial time.

*NP‑hardness.*  
We reduce the ordinary **CLIQUE** problem to CLIQUE‑DOM.

Let \(G=(V,E)\) and an integer \(k\) be an instance of CLIQUE.
Construct a new graph \(G'=(V',E')\) as follows.

* For every vertex \(v\in V\) create a vertex \(v'\in V'\).
* For every edge \(\{u,v\}\in E\) create the edge \(\{u',v'\}\in E'\).
* Add a new vertex \(x\) and join it to **every** vertex of \(V'\).

Thus \(V'=V\cup\{x\}\) and \(E'=E\cup\{\{x,v'\}\mid v'\in V'\}\).

The new vertex \(x\) is adjacent to all other vertices, so any
dominating set of \(G'\) must contain \(x\).  
Consequently a dominating set of size \(k+1\) in \(G'\) is exactly a
clique of size \(k\) in the original graph \(G\) together with the
vertex \(x\).

Therefore

\[
(G,k)\text{ is a YES‑instance of CLIQUE}\;\Longleftrightarrow\;
(G',k+1)\text{ is a YES‑instance of CLIQUE‑DOM}.
\]

The reduction is clearly polynomial, so CLIQUE‑DOM is NP‑hard.  
Together with membership in NP, the decision problem is NP‑complete.

---

### 2.  The optimisation problem is NP‑hard

Let  

\[
\text{MAX‑CLIQUE‑DOM}=\max\{|C|\mid C\subseteq V(G)\text{ is a dominating
clique}\}.
\]

Suppose we had a polynomial‑time algorithm \(A\) that, given a graph
\(G\), returns a dominating clique of maximum size.  
Run \(A\) on the graph \(G'\) constructed above and let the size of the
returned clique be \(s\).  
Because \(x\) must belong to every dominating clique of \(G'\), we have
\(s=k+1\) iff the original graph \(G\) contains a clique of size \(k\).
Thus we could solve CLIQUE in polynomial time, contradicting the
assumption that \(P\neq NP\).

Hence no polynomial‑time algorithm can find a maximum dominating clique
unless \(P=NP\); the optimisation problem is NP‑hard.

---

### 3.  Consequences

* The decision problem “does a graph contain a dominating clique of
  size at least k?” is NP‑complete.
* The optimisation problem “find a dominating clique of maximum
  cardinality” is NP‑hard.
* Consequently, unless \(P=NP\), there is no polynomial‑time algorithm
  that can compute the size of the largest dominating clique in an
  arbitrary graph.  Approximation or heuristic methods are therefore
  required for large instances.