module VerilogDM_143_206 (
  textInput, 
  publicKey,
  textOutput, 
  privateKey,
  encryptedData,
  clock
);

  input[15:0] textInput;    
  input[3:0] publicKey;     

  output[15:0] textOutput;  
  output[3:0] privateKey;                                                               
  output[3:0] encryptedData;                                                              

  input clock;                                                                              

  // Encryption
  encryption encode(textInput, publicKey, encryptedData, privateKey, clock); 
  
  // Decryption
  decryption decode(encryptedData, privateKey, publicKey, textOutput); 
endmodule

// Complete encryption module
module encryption (textInput, publicKey, encryptedText, privateKey, clock);
  input[15:0] textInput;         
  input[3:0] publicKey;                 

  output[3:0] encryptedText;             
  output[3:0] privateKey;               

  input clock;                              

  wire[0:3] encryptorOutput;
  wire[3:0] binaryToTextOutput;
  wire[3:0] toEncrypt;
  wire[3:0] privateKeyOutput, p;

  // Converts text to binary  
  encoder e1 (textInput, encryptorOutput);     

  // Negation operation (NOT)
  assign toEncrypt[3] = ~encryptorOutput[3];            
  assign toEncrypt[2] = ~encryptorOutput[2];
  assign toEncrypt[1] = ~encryptorOutput[1];
  assign toEncrypt[0] = ~encryptorOutput[0];

  // Converts binary to text code
  binaryToText b1(toEncrypt, binaryToTextOutput);    

  // Generates private key       
  privatekey p1(binaryToTextOutput, p);                
  register rr1(p, clock, privateKey);

  // XOR operation with private keys
  assign privateKeyOutput[3] = privateKey[3]^binaryToTextOutput[3];    
  assign privateKeyOutput[2] = privateKey[2]^binaryToTextOutput[2];
  assign privateKeyOutput[1] = privateKey[1]^binaryToTextOutput[1];
  assign privateKeyOutput[0] = privateKey[0]^binaryToTextOutput[0];

  // XOR operation with public keys
  assign encryptedText[3] = privateKeyOutput[3]^publicKey[3];     
  assign encryptedText[2] = privateKeyOutput[2]^publicKey[2];
  assign encryptedText[1] = privateKeyOutput[1]^publicKey[1];
  assign encryptedText[0] = privateKeyOutput[0]^publicKey[0];
endmodule

// Encodes text input then converts to binary
module encoder (textInput, binaryOutput);      
  input[15:0] textInput;                 
  output[3:0] binaryOutput;                           

  assign binaryOutput[0] = (
    textInput[1] | 
    textInput[3] | 
    textInput[5] |
    textInput[7] |
    textInput[9] |
    textInput[11]|
    textInput[13]|
    textInput[15]
  );

  assign binaryOutput[1] = (
    textInput[2] |
    textInput[3] |
    textInput[6] |
    textInput[7] |
    textInput[10]|
    textInput[11]|
    textInput[14]|
    textInput[15]
  );

  assign binaryOutput[2] = (
    textInput[4] |
    textInput[5] |
    textInput[6] |
    textInput[7] |
    textInput[12]|
    textInput[13]|
    textInput[14]|
    textInput[15]
  );

  assign binaryOutput[3] = (
    textInput[8] |
    textInput[9] |
    textInput[10]|
    textInput[11]|
    textInput[12]|
    textInput[13]|
    textInput[14]|
    textInput[15]
  );
endmodule

// Registers 4 bit modules
module register(inputData, clock, outputData);
  input[3:0] inputData;                          
  input clock;                                    

  output reg[3:0] outputData;                    
  
  always @ (inputData)

  // At positive edge of clock, output is equal to input
  outputData<=inputData;                    
endmodule

// Converts 4 bit binary to text code
module binaryToText(binaryInput, textOutput);            
  input[3:0] binaryInput;                            
  output[3:0] textOutput;                          

  assign textOutput[3] = binaryInput[3];
  assign textOutput[2] = binaryInput[3] ^ binaryInput[2];
  assign textOutput[1] = binaryInput[1] ^ binaryInput[2];
  assign textOutput[0] = binaryInput[1] ^ binaryInput[0];
endmodule

// 4 bit decoder module
module decoder(                                    
  input[3:0] binary,                               
  output[15:0] textOutput                            
);
  assign textOutput[0] = (~binary[3] & ~binary[2] & ~binary[1] & ~binary[0]);
  assign textOutput[1] = (~binary[3] & ~binary[2] & ~binary[1] & binary[0]);
  assign textOutput[2] = (~binary[3] & ~binary[2] & binary[1] & ~binary[0]);
  assign textOutput[3] = (~binary[3] & ~binary[2] & binary[1] & binary[0]);
  assign textOutput[4] = (~binary[3] & binary[2] & ~binary[1] & ~binary[0]);
  assign textOutput[5] = (~binary[3] & binary[2] & ~binary[1] & binary[0]);
  assign textOutput[6] = (~binary[3] & binary[2] & binary[1] & ~binary[0]);
  assign textOutput[7] = (~binary[3] & binary[2] & binary[1] & binary[0]);
  assign textOutput[8] = (binary[3] & ~binary[2] & ~binary[1] & ~binary[0]);
  assign textOutput[9] = (binary[3] & ~binary[2] & ~binary[1] & binary[0]);
  assign textOutput[10] = (binary[3] & ~binary[2] & binary[1] & ~binary[0]);
  assign textOutput[11] = (binary[3] & ~binary[2] & binary[1] & binary[0]);
  assign textOutput[12] = (binary[3] & binary[2] & ~binary[1] & ~binary[0]);
  assign textOutput[13] = (binary[3] & binary[2] & ~binary[1] & binary[0]);
  assign textOutput[14] = (binary[3] & binary[2] & binary[1] & ~binary[0]);
  assign textOutput[15] = (binary[3] & binary[2] & binary[1] & binary[0]);
endmodule
  
// converts 4 bit text code to binary
module textToBinary(textCode, binaryCode);   
  input [3:0] textCode;                        
  output [3:0] binaryCode;                       

  assign binaryCode[3] = textCode[3];
  assign binaryCode[2] = binaryCode[3] ^ textCode[2];
  assign binaryCode[1] = binaryCode[2] ^ textCode[1];
  assign binaryCode[0] = binaryCode[1] ^ textCode[0]; 
endmodule

// Complete decryption model
module decryption(encryptedData, privateKey, publicKey, textOutput);
  input [3:0] encryptedData;                                    
  input [3:0] privateKey;                                 
  input [3:0] publicKey;                                  
  output [15:0] textOutput;                      
  
  wire [3:0] publicXOR;         // Stores data after XOR operation with public key
  wire [3:0] privateXOR;        // Stores data after XOR operaton with private key
  wire [3:0] decryptedBinary;   // Stores data to be converted back to binary
  wire [3:0] negate;            // Stores data after NOT operation
  
  // XOR operation of encrypted data and public keys
  assign publicXOR[3] = encryptedData[3] ^ publicKey[3];          
  assign publicXOR[2] = encryptedData[2] ^ publicKey[2];
  assign publicXOR[1] = encryptedData[1] ^ publicKey[1];
  assign publicXOR[0] = encryptedData[0] ^ publicKey[0];
 
  // XOR operation with private keys
  assign privateXOR[3] = publicXOR[3] ^ privateKey[3];      
  assign privateXOR[2] = publicXOR[2] ^ privateKey[2];
  assign privateXOR[1] = publicXOR[1] ^ privateKey[1];
  assign privateXOR[0] = publicXOR[0] ^ privateKey[0];
  
  // Converts text to final binary code
  textToBinary gg(privateXOR, decryptedBinary);        
  
  // NOT operation
  assign negate[3] = ~decryptedBinary[0];                
  assign negate[2] = ~decryptedBinary[1];
  assign negate[1] = ~decryptedBinary[2];
  assign negate[0] = ~decryptedBinary[3];
  
  decoder dr(negate, textOutput);                 
endmodule
