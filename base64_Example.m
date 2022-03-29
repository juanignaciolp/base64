%%Simple Base64 encoder/decoder example script
clc;
 % String example taken from wikipedia: https://es.wikipedia.org/wiki/Base64
[fid,msg] = fopen('string.txt','rt'); 
str=[''];
while true
    str=[str,fgets(fid)];
 if  feof(fid)
     break;
 end
end
fclose(fid);
fprintf(1,['\nInput string:\n' str '\n']);

% Encode
base64_encoded_text=base64(str,'encode',true);

% Decode

base64_decoded_text=base64(base64_encoded_text,'decode',true);

%------Coded by Juan Ignacio Fernández -2022- -----------------------------