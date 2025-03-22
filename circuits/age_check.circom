pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/comparators.circom";

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
