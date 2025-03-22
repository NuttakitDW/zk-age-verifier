pragma circom 2.1.6;

// I can't import function from lib TT
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

// Circom circuits can only contain arithmetic constraints (quadratic equations over finite fields), 
// so direct comparisons like age >= minAge are not allowed.
template IsGreaterOrEqual(nBits) {
    signal input a;
    signal input b;
    signal output out;

    component isLess = LessThan(nBits);
    isLess.in[0] <== b;
    isLess.in[1] <== a;

    out <== isLess.out;
}

template AgeCheck(minAge) {
    // Public input: hash of the user's age
    signal input ageHash;

    // Private input: the actual age
    signal input age;

    // Compute hash of age
    signal computedHash;

    // Check if age >= minAge
    signal isOldEnough;

    computedHash <== age * 123456789; // Simple deterministic hash
    ageHash === computedHash;

    component check = IsGreaterOrEqual(8);
    check.a <== age;
    check.b <== minAge;

    // Require out == 1 (i.e. age >= minAge)
    check.out === 1;
}

component main = AgeCheck(18);
