clc;
clear;
close all;

%% ================= USER INPUT =================
M = input('Enter the message: ','s');

fprintf('\nOriginal Message: %s\n', M);

%% ================= SIMPLE HASH =================
% Convert message to ASCII
M_bytes = double(M);

% Simple hash (for learning): sum mod n
hash_M = mod(sum(M_bytes), 1000);

fprintf('Message Hash: %d\n', hash_M);

%% ================= RSA KEY GENERATION =================
% Small primes (for demo only)
p = 61;
q = 53;
n = p * q;              % modulus
phi = (p-1)*(q-1);

e = 17;                 % public key
d = modInverse(e, phi);% private key

fprintf('\nPublic Key (e, n): (%d, %d)\n', e, n);
fprintf('Private Key (d, n): (%d, %d)\n', d, n);

%% ================= SIGNING (Sender Side) =================
% Signature = Hash^d mod n
signature = modExp(hash_M, d, n);

fprintf('\nDigital Signature: %d\n', signature);

%% ================= VERIFICATION (Receiver Side) =================
% Decrypt signature using public key
verified_hash = modExp(signature, e, n);

fprintf('Verified Hash: %d\n', verified_hash);

%% ================= RESULT =================
if verified_hash == hash_M
    disp('Digital Signature VERIFIED');
else
    disp('Digital Signature INVALID');
end

%% ================= FUNCTIONS =================
function d = modInverse(e, phi)
    % Extended Euclidean Algorithm
    [g, x, ~] = gcd(e, phi);
    if g ~= 1
        error('Inverse does not exist');
    end
    d = mod(x, phi);
end

function y = modExp(base, exp, modn)
    % Modular exponentiation
    y = 1;
    for i = 1:exp
        y = mod(y * base, modn);
    end
end