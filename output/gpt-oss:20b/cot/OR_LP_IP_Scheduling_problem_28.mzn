**Answer**

The question is asking whether the statement

> “If a set of points is convex, then the convex hull of that set is also convex”

is true or false.  
The statement is **true**.  
The convex hull of any set of points is, by definition, the smallest convex set that contains the original set. Therefore, if the original set is already convex, its convex hull is simply the set itself, which is convex.  

**Proof**

Let \(S\subseteq\mathbb{R}^n\) be a convex set.  
The convex hull of \(S\) is defined as

\[
\operatorname{conv}(S)=\bigcap\{C\subseteq\mathbb{R}^n\mid C\text{ is convex and }S\subseteq C\}.
\]

Because \(S\) is convex and \(S\subseteq S\), the intersection above contains \(S\).  
But the intersection of all convex supersets of \(S\) cannot be larger than \(S\) itself, otherwise \(S\) would not be the smallest convex set containing \(S\).  
Hence \(\operatorname{conv}(S)=S\).

Since \(S\) is convex, \(\operatorname{conv}(S)\) is convex. ∎

**Answer**: True.