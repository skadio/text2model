**Answer to the first question**

Let  

\[
X_{1},X_{2},\dots ,X_{n}\stackrel{\text{i.i.d.}}{\sim}\text{Uniform}(0,1)
\]

and let  

\[
M_{n}=\max \{X_{1},\dots ,X_{n}\}.
\]

The distribution function of \(M_{n}\) is  

\[
F_{M_{n}}(x)=P(M_{n}\le x)=x^{\,n},\qquad 0\le x\le 1 .
\]

Hence the density of \(M_{n}\) is  

\[
f_{M_{n}}(x)=n\,x^{\,n-1},\qquad 0\le x\le 1 .
\]

The expected value of \(M_{n}\) is

\[
E[M_{n}]
   =\int_{0}^{1}x\,f_{M_{n}}(x)\,dx
   =\int_{0}^{1}n\,x^{\,n}\,dx
   =\frac{n}{n+1}.
\]

So the mean of the maximum of \(n\) independent \(\text{Uniform}(0,1)\) variables is  

\[
\boxed{\displaystyle E[M_{n}]=\frac{n}{\,n+1\,}} .
\]

---

**Answer to the second question**

Let \(X\sim\text{Uniform}(0,1)\) and let \(Y\) be a Bernoulli random variable with  

\[
P(Y=1)=p,\qquad P(Y=0)=1-p ,
\]

independent of \(X\).  
Define  

\[
Z=Y\,X .
\]

The distribution of \(Z\) is a mixture of a point mass at \(0\) and a
continuous part on \((0,1]\):

\[
P(Z=0)=P(Y=0)=1-p .
\]

For \(z>0\),

\[
P(Z\le z)=P(Y=0)+P(Y=1,\;X\le z)
          =(1-p)+p\,z ,\qquad 0<z\le 1 .
\]

Thus the cumulative distribution function of \(Z\) is

\[
F_{Z}(z)=
\begin{cases}
0, & z<0,\\[4pt]
1-p, & z=0,\\[4pt]
(1-p)+p\,z, & 0<z\le 1,\\[4pt]
1, & z>1 .
\end{cases}
\]

The density on \((0,1]\) is

\[
f_{Z}(z)=p,\qquad 0<z\le 1 .
\]

The expected value of \(Z\) is

\[
E[Z]=E[Y\,X]=E[Y]\,E[X]=p\cdot \frac12=\frac{p}{2}.
\]

So the random variable \(Z=Y\,X\) has a point mass \(1-p\) at \(0\) and a
uniform density \(p\) on \((0,1]\); its mean is \(p/2\).