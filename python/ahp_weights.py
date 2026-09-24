import numpy as np
from fractions import Fraction

FACTORS = ["slope", "lithology", "faults", "rainfall", "landcover", "twi", "curvature", "drainage", "aspect"]
UPPER = [
    [2, 3, 3, 4, 5, 6, 7, 8], [2, 2, 3, 4, 5, 6, 7], [2, 3, 3, 4, 5, 6],
    [2, 3, 4, 5, 6], [2, 3, 4, 5], [2, 3, 4], [2, 3], [2]]
RI = {3: 0.58, 4: 0.90, 5: 1.12, 6: 1.24, 7: 1.32, 8: 1.41, 9: 1.45, 10: 1.49}

def pairwise_matrix(upper):
    n = len(upper) + 1
    A = np.ones((n, n))
    for i, row in enumerate(upper):
        for k, v in enumerate(row):
            j = i + 1 + k
            A[i, j] = float(Fraction(v)); A[j, i] = 1.0 / A[i, j]
    return A

def ahp(A):
    vals, vecs = np.linalg.eig(A)
    k = np.argmax(vals.real)
    w = np.abs(vecs[:, k].real); w /= w.sum()
    n = A.shape[0]; lam = vals[k].real
    ci = (lam - n) / (n - 1); cr = ci / RI[n]
    return w, lam, ci, cr

def renormalise(w, keep):
    sub = np.array([w[FACTORS.index(f)] for f in keep]); return dict(zip(keep, sub / sub.sum()))

if __name__ == "__main__":
    w, lam, ci, cr = ahp(pairwise_matrix(UPPER))
    print(f"lambda_max={lam:.3f}  CI={ci:.4f}  CR={cr:.4f}")
    for f, x in zip(FACTORS, w): print(f"{f:10s} {x:.4f}")
    print(renormalise(w, ["slope", "lithology", "faults", "landcover", "curvature", "aspect"]))
