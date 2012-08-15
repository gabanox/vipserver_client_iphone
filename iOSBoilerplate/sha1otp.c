#include "hmacsha1.h"
#include "sha1otp.h"
#include <string.h>


#define TEXT_SIZE 8

static char     double_digits[] = { 0, 2, 4, 6, 8, 1, 3, 5, 7, 9 };
int
checksum(char *num)
{
    int             digits = strlen(num);
    int             doubleDigit = 1;
    int             total = 0;
    int             result;
    while (0 < digits--) {
	int             digit = num[digits] - '0';
	total += doubleDigit ? double_digits[digit] : digit;
	doubleDigit = !doubleDigit;
    }
    result = total % 10;
    if (result > 0) {
	result = 10 - result;
    }
    return result + '0';
}


u_int32_t gen_binary_otp(const char * key, int key_size, int64_t moving_factor)
{
    char            text[TEXT_SIZE];
    char            hashcode[20];
    int             i,
                    offset;
    u_int32_t         binary;

    /* put dynamic value into text byte array */
    for (i = TEXT_SIZE - 1; i >= 0; i--) {
	text[i] = (unsigned char) (moving_factor & 0xff);
	moving_factor >>= 8;
    }
    /* compute hmac hash */
    hmac_sha1(hashcode, key, key_size, text, TEXT_SIZE);

    /* put selected bytes into result int */
    offset = hashcode[19] & 0xf;
    binary = ((hashcode[offset] & 0x7f) << 24)
	| ((hashcode[offset + 1] & 0xff) << 16)
	| ((hashcode[offset + 2] & 0xff) << 8)
	| ((hashcode[offset + 3] & 0xff));
    return binary;
}


#define ERR_BUFFER_TOO_SMALL	-13

int hmac_sha1_otp_len(int param) {
    return (param & 0xf) + ((param>>4) & 0x1);
}

int hmac_sha1_otp(int param, const char * key, int key_size, int64_t moving_factor, char *response, int response_bytes)
{
    u_int32_t         otp = gen_binary_otp(key, key_size, moving_factor);
    int             digits = param & 0x0f;
    int             has_checksum = (param & 0x10) != 0;
    int             total_digits = digits + has_checksum;
    int             i = total_digits-1;
    memset(response, 0, response_bytes);
    if ((digits + has_checksum + 1) > response_bytes) {
	return ERR_BUFFER_TOO_SMALL;
    }
    if (has_checksum) { i--; }
    while (i >= 0) {
	response[i--] = (char)('0' + (otp % 10));
	otp /= 10;
    }
    if (has_checksum) {
	response[total_digits - 1] = checksum(response);
    }
    return 0;
}
