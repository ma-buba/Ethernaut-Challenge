from Crypto.Hash import keccak

p  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
n  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
Gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
Gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
G = (Gx, Gy)

def inv(a, m): return pow(a % m, -1, m)

def ec_add(P, Q):
    if P is None: return Q
    if Q is None: return P
    (x1,y1),(x2,y2) = P,Q
    if x1 == x2 and (y1+y2) % p == 0: return None
    if P == Q:
        l = (3*x1*x1) * inv(2*y1, p) % p
    else:
        l = (y2-y1) * inv(x2-x1, p) % p
    x3 = (l*l - x1 - x2) % p
    y3 = (l*(x1-x3) - y1) % p
    return (x3, y3)

def ec_mul(k, P):
    R = None
    k = k % n
    while k:
        if k & 1: R = ec_add(R, P)
        P = ec_add(P, P)
        k >>= 1
    return R

def eth_address_from_priv(d):
    Px, Py = ec_mul(d, G)
    kk = keccak.new(digest_bits=256); kk.update(Px.to_bytes(32,'big')+Py.to_bytes(32,'big'))
    return '0x' + kk.hexdigest()[-40:]

def eth_address_from_pub(Px, Py):
    kk = keccak.new(digest_bits=256); kk.update(Px.to_bytes(32,'big')+Py.to_bytes(32,'big'))
    return '0x' + kk.hexdigest()[-40:]

def eth_signed_hash(msg):
    prefix = b"\x19Ethereum Signed Message:\n" + str(len(msg)).encode()
    kk = keccak.new(digest_bits=256); kk.update(prefix+msg)
    return int.from_bytes(kk.digest(),'big')

def build_admin_message(nonce_val, addr_hex):
    return b"admin" + str(nonce_val).encode() + bytes.fromhex(addr_hex[2:])

def build_lock_message(nonce_val):
    return b"lock" + str(nonce_val).encode()

def raw_sig(d, h, k):
    R = ec_mul(k, G)
    r = R[0] % n
    s_raw = (inv(k,n) * (h + r*d)) % n
    return r, s_raw

def to_low_s(r, s_raw, y_parity):
    if s_raw > n//2:
        return r, n - s_raw, 27 + (1 - y_parity)
    return r, s_raw, 27 + y_parity

def ecrecover(h, v, r, s):
    rec_id = v - 27
    x = r
    y = pow((x*x*x+7) % p, (p+1)//4, p)
    if y % 2 != rec_id % 2: y = p - y
    R = (x, y)
    r_inv = inv(r, n)
    sR = ec_mul(s, R)
    hG = ec_mul(h % n, G)
    Q = ec_mul(r_inv, ec_add(sR, (hG[0], (p-hG[1]) % p)))
    return Q

d = 0xA11CE5A11CE5A11CE5A11CE5A11CE5A11CE5A11CE5A11CE5A11CE5A11CE5A11 % n
owner_addr = eth_address_from_priv(d)
legit_admin = "0x" + "12".rjust(40,'0')
attacker    = "0x" + "99".rjust(40,'0')

# ---- historical, reused-k signatures (submitted on-chain, must be low-s valid) ----
k_reused = 0xDEADBEEFCAFEBABEDEADBEEFCAFEBABEDEADBEEFCAFEBABEDEADBEEFCAFEBABE % n
Rk = ec_mul(k_reused, G)
y_parity = Rk[1] % 2

hA = eth_signed_hash(build_admin_message(0, legit_admin))
hB = eth_signed_hash(build_lock_message(1))

rA, sA_raw = raw_sig(d, hA, k_reused)
rB, sB_raw = raw_sig(d, hB, k_reused)
rA, sA, vA = to_low_s(rA, sA_raw, y_parity)
rB, sB, vB = to_low_s(rB, sB_raw, y_parity)

# sanity: both submitted sigs individually verify
for (h,v,r,s,label) in [(hA,vA,rA,sA,'sigA'),(hB,vB,rB,sB,'sigB')]:
    Q = ecrecover(h,v,r,s)
    ok = eth_address_from_pub(*Q) == owner_addr
    print(f"{label} valid on-chain (ecrecover==owner)? {ok}")

# ---- attacker recovers d using the RAW (pre-low-s) s values ----
k_rec = ((hA - hB) * inv(sA_raw - sB_raw, n)) % n
d_rec = ((sA_raw * k_rec - hA) * inv(rA, n)) % n
print("recovered d correct?", d_rec == d)

# ---- forged exploit signatures, targeting nonce AFTER sigA/sigB are consumed (nonce=2,3) ----
hC = eth_signed_hash(build_admin_message(2, attacker))
rC_raw, sC_raw = raw_sig(d_rec, hC, 0x1111111111111111111111111111111111111111111111111111111111111111 % n)
Rc = ec_mul(0x1111111111111111111111111111111111111111111111111111111111111111 % n, G)
rC, sC, vC = to_low_s(rC_raw, sC_raw, Rc[1] % 2)

hD = eth_signed_hash(build_lock_message(3))
rD_raw, sD_raw = raw_sig(d_rec, hD, 0x2222222222222222222222222222222222222222222222222222222222222222 % n)
Rd = ec_mul(0x2222222222222222222222222222222222222222222222222222222222222222 % n, G)
rD, sD, vD = to_low_s(rD_raw, sD_raw, Rd[1] % 2)

for (h,v,r,s,label) in [(hC,vC,rC,sC,'sigC(setAdmin nonce2->attacker)'),(hD,vD,rD,sD,'sigD(switchLock nonce3)')]:
    Q = ecrecover(h,v,r,s)
    ok = eth_address_from_pub(*Q) == owner_addr
    print(f"{label} valid on-chain (ecrecover==owner)? {ok}")

print()
print("owner_addr  =", owner_addr)
print("legit_admin =", legit_admin)
print("attacker    =", attacker)
print()
print("sigA:", f'hex"{rA:064x}{sA:064x}{vA:02x}"')
print("sigB:", f'hex"{rB:064x}{sB:064x}{vB:02x}"')
print("sigC:", f'hex"{rC:064x}{sC:064x}{vC:02x}"')
print("sigD:", f'hex"{rD:064x}{sD:064x}{vD:02x}"')
