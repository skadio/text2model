import sys

def solve() -> None:
    tokens = sys.stdin.read().strip().split()
    if not tokens:
        return
    n = int(tokens[0])
    a = list(map(int, tokens[1:1 + n]))
    total = sum(a)
    ans = (total + n - 1) // n
    print(ans)

if __name__ == "__main__":
    solve()