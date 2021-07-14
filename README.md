# Binary to Text Encryption/Decryption Module

This model demonstrates the basic encryption of data using various keys and methods and then finally decrypting the data back to the original data.

Functionality: 

* Initially we take a text input and convert it into binary format using 4 bit encoder.
* Then this input is negated by passing through NOT logic gates. 
* This input is passed through binary to text converter.
* This input is further passed to a private key generator which generates a private key using inputs.
* The previous input is XOR with private key, this is the first encryption layer.
* Then the input is passed through XOR operations with public key, second encryption layer.
* Final encrypted input is now generated and further passed to decryption model with private key.
* On decryption side the input is made with XOR operations using public key.
* Then this input is passed through XOR operations with private key.
* The previous output generated is passed to text to binary converter.
* Then this is negated by passing through NOT logic gates.
* This data is passed through 4 bit decoder to get back the final text decoded value.
