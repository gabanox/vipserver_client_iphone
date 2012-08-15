#include "hmacsha1.h"


#define HASH_BLOCK_SIZE	64

const char IPAD_BYTE = 0x36;
const char OPAD_BYTE = 0x5c;


/*
 * ipad = the byte 0x36 repeated B times opad = the byte 0x5C repeated B
 * times.
 * 
 * To compute HMAC over the data `text' we perform
 * 
 * H(K XOR opad, H(K XOR ipad, text)) 
 */
void SHA1hash2(char result[20], const char * data1, int size1, const char * data2, int size2)
{
    SHA1_CTX        ctx;
    SHA1Init(&ctx);
    SHA1Update(&ctx, data1, size1);
    SHA1Update(&ctx, data2, size2);
    SHA1Final(result, &ctx);
	
}


void hmac_sha1(char result[20], const char * key, int ksize, const char * text, int tsize)
{
    int i;
    char iblock[HASH_BLOCK_SIZE];
    char oblock[HASH_BLOCK_SIZE];
    char ihash[20];

	
	
    if (ksize > HASH_BLOCK_SIZE) {
		ksize = HASH_BLOCK_SIZE;
    }
    
	for (i = 0; i < ksize; i++) {
		iblock[i] = (IPAD_BYTE ^ key[i]);
		oblock[i] = (OPAD_BYTE ^ key[i]);
    }
    
	for (i = ksize; i < HASH_BLOCK_SIZE; i++) {
		iblock[i] = IPAD_BYTE;
		oblock[i] = OPAD_BYTE;
    }
	
    SHA1hash2(ihash, iblock, HASH_BLOCK_SIZE, text, tsize);
    SHA1hash2(result, oblock, HASH_BLOCK_SIZE, ihash, 20);
}
