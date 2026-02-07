clc;
clear;
close all;

%% ===================== GUI WINDOW =====================
f = figure('Name','Public-Key Cryptosystem Demo', ...
           'Position',[400 200 520 380], ...
           'NumberTitle','off');

%% ===================== RECEIVER SIDE =====================
uicontrol(f,'Style','text','Position',[30 330 200 20], ...
          'String','RECEIVER SIDE (Key Setup)','FontWeight','bold');

uicontrol(f,'Style','text','Position',[30 300 120 20], ...
          'String','Public Key');

handles.pubKey = uicontrol(f,'Style','edit','Position',[160 300 100 25]);

uicontrol(f,'Style','text','Position',[30 260 120 20], ...
          'String','Private Key');

handles.privKey = uicontrol(f,'Style','edit','Position',[160 260 100 25]);

%% ===================== SENDER SIDE =====================
uicontrol(f,'Style','text','Position',[30 220 200 20], ...
          'String','SENDER SIDE','FontWeight','bold');

uicontrol(f,'Style','text','Position',[30 190 120 20], ...
          'String','Plaintext');

handles.ptBox = uicontrol(f,'Style','edit','Position',[160 190 300 25]);

%% ===================== BUTTON =====================
uicontrol(f,'Style','pushbutton','Position',[200 140 120 35], ...
          'String','Encrypt & Decrypt', ...
          'Callback',@encryptDecryptCallback);

%% ===================== OUTPUT =====================
uicontrol(f,'Style','text','Position',[30 100 120 20], ...
          'String','Ciphertext');

handles.ctBox = uicontrol(f,'Style','edit','Position',[160 100 300 25], ...
                          'Enable','inactive');

uicontrol(f,'Style','text','Position',[30 60 120 20], ...
          'String','Decrypted Text');

handles.dtBox = uicontrol(f,'Style','edit','Position',[160 60 300 25], ...
                          'Enable','inactive');

guidata(f,handles);

%% ===================== CALLBACK FUNCTION =====================
function encryptDecryptCallback(~,~)
    handles = guidata(gcf);

    % Get inputs
    plaintext = get(handles.ptBox,'String');
    pubKey = str2double(get(handles.pubKey,'String'));
    privKey = str2double(get(handles.privKey,'String'));

    if isempty(plaintext)
        errordlg('Plaintext cannot be empty');
        return;
    end

    if isnan(pubKey) || isnan(privKey)
        errordlg('Keys must be numeric');
        return;
    end

    % Convert plaintext to ASCII
    pt_ascii = double(plaintext);

    % Encrypt using PUBLIC KEY
    ciphertext = bitxor(pt_ascii, pubKey);

    % Decrypt using PRIVATE KEY
    decrypted_ascii = bitxor(ciphertext, privKey);
    decrypted_text = char(decrypted_ascii);

    % Display results
    set(handles.ctBox,'String',mat2str(ciphertext));
    set(handles.dtBox,'String',decrypted_text);

    % Verification message
    if strcmp(plaintext, decrypted_text)
        msgbox('Decryption Successful','Success');
    else
        msgbox('Decryption Failed (Wrong Key)','Error');
    end
end