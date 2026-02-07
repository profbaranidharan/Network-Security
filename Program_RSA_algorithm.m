clc;
clear;
close all;

disp('========== RSA ALGORITHM ==========');

%% ================= KEY GENERATION =================
% Receiver side (Alice)

p = input('Enter prime number p: ');
q = input('Enter prime number q: ');

n = p * q;
phi_n = (p - 1) * (q - 1);

fprintf('n = %d\n', n);
fprintf('phi(n) = %d\n', phi_n);

% Choose public key e
e = input('Enter public key e (gcd(e,phi(n)) = 1): ');

% Check validity of e
if gcd(e, phi_n) ~= 1
    error('e is not relatively prime to phi(n)');
end

% Compute private key d
d = modInverse(e, phi_n);

fprintf('Public Key  (e,n) = (%d,%d)\n', e, n);
fprintf('Private Key (d,n) = (%d,%d)\n', d, n);

%% ================= ENCRYPTION =================
% Sender side (Bob)

M = input('Enter plaintext (integer < n): ');

if M >= n
    error('Plaintext must be less than n');
end

C = modExp(M, e, n);

fprintf('Ciphertext C = %d\n', C);

%% ================= DECRYPTION =================
% Receiver side (Alice)

M_dec = modExp(C, d, n);

fprintf('Decrypted Plaintext = %d\n', M_dec);

%% ================= VERIFICATION =================
if M == M_dec
    disp('Decryption Successful');
else
    disp('Decryption Failed');
end


%% ============== FUNCTIONS =================

function result = modExp(base, exponent, modulus)
% Efficient modular exponentiation
    result = 1;
    base = mod(base, modulus);

    while exponent > 0
        if mod(exponent,2) == 1
            result = mod(result * base, modulus);
        end
        exponent = floor(exponent / 2);
        base = mod(base * base, modulus);
    end
end

function d = modInverse(e, phi)
% Compute modular inverse using brute force (simple & clear)
    for k = 1:phi
        if mod(e*k, phi) == 1
            d = k;
            return;
        end
    end
    error('Modular inverse does not exist');
end