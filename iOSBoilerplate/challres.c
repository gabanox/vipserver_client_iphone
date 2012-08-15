#include "challres.h"
#include "sha1otp.h"
#include <stdlib.h>
#include <string.h>

// HOTP event based is 0x106
// 3DES challenge-response is 0x206
// HOTP time based is 0x306
// After shitting 8 bits, 1 is event based HOTP
// After shitting 8 bits, 2 is challenge-response 
// After shitting 8 bits, 3 is time based HOTP
#define HMAC_SHA1_OTP_E     1
#define H3DES_CHALL_RESP    2
#define HMAC_SHA1_OTP_T     3

int response_bytes(int algorithm) {
    int size = 0;

    switch (algorithm >> 8) {
    case HMAC_SHA1_OTP_E:
    case HMAC_SHA1_OTP_T:
       size = hmac_sha1_otp_len(algorithm)+1;
       break;
    }
    return size;
}

int get_otp(int algorithm, const char * key, int key_bytes, int64_t moving_factor, char *response, int response_bytes)
{
    int param = algorithm & 0xff;
    int result = 0;

	switch (algorithm >> 8) {
    case HMAC_SHA1_OTP_E:
    case HMAC_SHA1_OTP_T:
        result = hmac_sha1_otp(param, key, key_bytes, moving_factor,
                response, response_bytes);
        break;
    default:
        result = -1;
    }

    return result;
}


/* 
 * all other parameters are the same as get_otp
 *
 * rt is the relative time, difference between current time and starting time
 * ts is the time elapse contributed step for example 30 seconds as 1 time step
 *
 * returns -1 if the parameters provided are incorrect.
 */
int get_hotp(int algorithm, const char * key, int key_bytes, int rt, int ts, char *response, int response_bytes)
{
    int64_t moving_factor;

    moving_factor = getHOTPMovingFactor(rt, ts);

    if (moving_factor == -1)
    {
        return -1;
    }

    return get_otp(algorithm, key, key_bytes, moving_factor, response, response_bytes);
}

/* This function takes in the moving factor parameters required for computing the OTP for
 * OATH time based tokens and returns the corresponding OTP.
 * rt is the relative time, difference between current time and starting time
 * ts is the time elapse contributed step for example 30 seconds as 1 time step
 *
 * returns -1 if the parameters provided are incorrect.
 */
int64_t getHOTPMovingFactor(int rt, int ts)
{
    int64_t moving_factor;

    if (rt < 0 || ts <= 0)
    {
        return -1;
    }
    moving_factor = (int64_t)( rt/ts );

    return moving_factor;
}
