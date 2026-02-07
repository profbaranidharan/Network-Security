function MessageAuthentication_GUI
clc; close all;

%% ===================== GUI WINDOW =====================
f = figure('Name','Message Authentication GUI', ...
           'Position',[400 200 650 500], ...
           'NumberTitle','off', ...
           'Resize','off');

%% ===================== INPUT FIELDS =====================
uicontrol(f,'Style','text','Position',[40 450 150 20], ...
          'String','Message (M):','FontSize',10,'HorizontalAlignment','left');

txtM = uicontrol(f,'Style','edit','Position',[200 450 380 25], ...
                 'FontSize',10);

uicontrol(f,'Style','text','Position',[40 410 150 20], ...
          'String','Symmetric Key (number):','FontSize',10,'HorizontalAlignment','left');

txtK = uicontrol(f,'Style','edit','Position',[200 410 380 25], ...
                 'FontSize',10);

uicontrol(f,'Style','text','Position',[40 370 150 20], ...
          'String','Shared Secret (S):','FontSize',10,'HorizontalAlignment','left');

txtS = uicontrol(f,'Style','edit','Position',[200 370 380 25], ...
                 'FontSize',10);

%% ===================== BUTTON =====================
uicontrol(f,'Style','pushbutton','String','Run Authentication', ...
          'Position',[220 320 200 35], ...
          'FontSize',11,'Callback',@runAuth);

%% ===================== OUTPUT BOX =====================
uicontrol(f,'Style','text','Position',[40 285 150 20], ...
          'String','Output:','FontSize',10,'HorizontalAlignment','left');

txtOut = uicontrol(f,'Style','listbox','Position',[40 40 560 240], ...
                   'FontSize',10);

%% ===================== CALLBACK FUNCTION =====================
    function runAuth(~,~)
        % Read inputs
        M = get(txtM,'String');
        K = str2double(get(txtK,'String'));
        S = get(txtS,'String');

        if isempty(M) || isnan(K) || isempty(S)
            set(txtOut,'String',{'Please enter all inputs correctly'});
            return;
        end

        M_bytes = double(M);
        S_bytes = double(S);

        out = {};
        out{end+1} = ['Original Message: ', M];
        out{end+1} = ' ';

        %% Hash
        hash_M = simpleHash(M_bytes);

        %% (a) Encrypt Message + Hash
        data_a = [M_bytes hash_M];
        cipher_a = bitxor(data_a, K);
        plain_a  = bitxor(cipher_a, K);

        recv_hash_a = plain_a(end);
        check_hash  = simpleHash(plain_a(1:end-1));

        if recv_hash_a == check_hash
            out{end+1} = 'Method (a): Authentication Successful';
        else
            out{end+1} = 'Method (a): Authentication Failed';
        end

        %% (b) Encrypt Only Hash
        enc_hash_b = bitxor(hash_M, K);
        dec_hash_b = bitxor(enc_hash_b, K);

        if dec_hash_b == simpleHash(M_bytes)
            out{end+1} = 'Method (b): Authentication Successful';
        else
            out{end+1} = 'Method (b): Authentication Failed';
        end

        %% (c) Hash with Shared Secret
        hash_c = simpleHash([M_bytes S_bytes]);
        check_hash = simpleHash([M_bytes S_bytes]);

        if hash_c == check_hash
            out{end+1} = 'Method (c): Authentication Successful';
        else
            out{end+1} = 'Method (c): Authentication Failed';
        end

        %% (d) Hash + Secret + Encryption
        data_d = [M_bytes hash_c];
        cipher_d = bitxor(data_d, K);
        plain_d  = bitxor(cipher_d, K);

        recv_hash_d = plain_d(end);
        check_hash  = simpleHash([plain_d(1:end-1) S_bytes]);

        if recv_hash_d == check_hash
            out{end+1} = 'Method (d): Authentication Successful';
        else
            out{end+1} = 'Method (d): Authentication Failed';
        end

        set(txtOut,'String',out);
    end
end

%% ===================== SIMPLE HASH FUNCTION =====================
function h = simpleHash(data)
    h = mod(sum(data),256);
end