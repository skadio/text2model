import sys

# ---------- Disjoint Set Union ----------
class DSU:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra == rb:
            return False
        if self.rank[ra] < self.rank[rb]:
            ra, rb = rb, ra
        self.parent[rb] = ra
        if self.rank[ra] == self.rank[rb]:
            self.rank[ra] += 1
        return True

# ---------- Main solver ----------
def solve() -> None:
    data = list(map(int, sys.stdin.buffer.read().split()))
    it = iter(data)
    t = next(it)
    out_lines = []

    for _ in range(t):
        n = next(it)
        m = next(it)
        k = next(it)          # not used explicitly
        c = next(it)

        edges = []

        # original roads
        for _ in range(m):
            u = next(it)
            v = next(it)
            w = next(it)
            edges.append((w, u, v))

        # edges from virtual node 0 to every city
        for city in range(1, n + 1):
            edges.append((c, city, 0))

        # Kruskal
        edges.sort(key=lambda x: x[0])
        dsu = DSU(n + 1)          # vertices 0..n
        total = 0
        chosen = 0

        for w, u, v in edges:
            if dsu.union(u, v):
                total += w
                chosen += 1
                if chosen == n:   # MST complete
                    break

        out_lines.append(str(total))

    sys.stdout.write("\n".join(out_lines))

if __name__ == "__main__":
    solve()