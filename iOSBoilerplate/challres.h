

/*
 * chalres.h Overview:
 *
 * This interface is to be used to generate both One-Time-Passwords and
 * responses to a challenge.  Additionally, this interface is designed
 * to allow future additional algorithms to be plugged in at a later
 * time but still be selected by existing code.
 *
 * None of the functions in this interface allocate any memory!  They expect
 * the response string parameter to be pre-allocated to be at least as large
 * as the return value from response_bytes() for a given algorithm.
 *
 * The first parameter to each of the functions is the algorithm to be
 * used to generate a response.
 *
 * The high order bytes (algorithm >> 8) determine which primary algorithm
 * will be used to generate the response; the low order byte of the
 * algorithm is parameter information specific to each primary algorithm.
 *
 * This interface defines the following macro:
 *
 *    HSHA1_OTP_ALGORITHM() - generates an HMAC-SHA1-OTP algorithm number.
 *
 * This interface defines the following functions:
 *
 *     response_bytes() - indicates how many bytes are needed to store the
 *                        response string, including the null termination
 *                        byte.
 *
 *     get_response()   - gets a response string given a key and an
 *                        ascii text challenge string.
 *
 *     get_otp()        - gets an otp response string given a secret
 *                        and a numeric (64 bit) moving factor.
 *
 */

/*
 * HSHA1_OTP_ALGORITHM() macro
 * This macro generates an algorithm number for the HMAC-SHA1-OTP algorithm
 * which has a primary algorithm value of 1.
 * This algorithm has two parameters described as follows:
 *
 * CODE_DIGITS  - The number of digits directly derived from the secret
 *                and the moving factor.  The low order 4 bits (param & 0xf)
 *                is the number of code digits.
 *
 * HAS_CHECKSUM - This bit is 1 if there is a checksum digit and 0 if
 *                there is not.  This is the 5th bit ((param >> 4) & 1).
 *
 */

#define HSHA1_OTP_ALGORITHM(CODE_DIGITS,HAS_CHECKSUM)	\
	(0x100 | (((HAS_CHECKSUM)!=0)<<4) | ((CODE_DIGITS)&0xf) )

#define CHALLENGE_RESPONSE_3DES_ALGORITHM(CODE_DIGITS,HAS_CHECKSUM)	\
	(0x200 | (((HAS_CHECKSUM)!=0)<<4) | ((CODE_DIGITS)&0xf) )

/*
 * function response_bytes() - indicates how many bytes are needed to
 *                             store the response string, including the
 *                             null termination byte.
 *
 *     parameters:
 *
 *         algorithm  - The algorithm to get the response size of.
 *                      See Above for a discussion for algorithm.
 */
 #include <sys/types.h>
 
	int             response_bytes(int algorithm);


/*
 *
 *     get_otp()        - gets an otp response string given a secret
 *                        and a numeric (64 bit) moving factor.
 *
 * function get_otp() - gets a text otp response string given a key and
 *                      a numeric moving-factor (count or time value).
 *                      This entry-point is provided for efficiency to avoid
 *                      converting a challenge to a string and then back to a
 *                      64-bit integer when the challenge is known to be
 *                      numeric.
 *
 *     parameters:
 *
 *         algorithm      - algorithm number to use to get the response
 *                          See Above for a discussion for algorithm.
 * 
 *         key            - the share secret that is used as a basis
 *                          for generating the response.
 * 
 *         key_bytes      - the number of bytes in the key.
 * 
 *         moving_factor  - A 64-bit integer value that is used in combination
 *                          with the key to compute the OTP response.
 * 
 *         response       - the output buffer where the null-terminated
 *                          response will be put.  The caller is expected to
 *                          allocate this buffer before calling this function.
 *                          This buffer is expected to be at least
 *                          response_bytes long.
 * 
 *         response_bytes - The size in bytes of the response buffer.  This
 *                          value should be at least as large as the value
 *                          returned from response_bytes(algorithm).
 */

    int             get_otp(int algorithm, 
		const char * key, 
		int key_bytes,
			    int64_t moving_factor,
			    char *response, int response_bytes);

/*
 *         algorithm      - algorithm number to use to get the response
 *                          See Above for a discussion for algorithm.
 * 
 *         key            - the share secret that is used as a basis
 *                          for generating the response.
 * 
 *         key_bytes      - the number of bytes in the key.
 * 
 *
 *         rt             - is the relative time, difference between current time and starting time
 *
 *         ts             - is the time elapse contributed step for example 30 seconds as 1 time step (or the time-step window)
 * 
 *         response       - the output buffer where the null-terminated
 *                          response will be put.  The caller is expected to
 *                          allocate this buffer before calling this function.
 *                          This buffer is expected to be at least
 *                          response_bytes long.
 * 
 *         response_bytes - The size in bytes of the response buffer.  This
 *                          value should be at least as large as the value
 *                          returned from response_bytes(algorithm).
 *
 */
     int           get_hotp(int algorithm, const char * key, int key_bytes,
                             int rt, int ts,
                             char *response, int response_bytes);

/* This function takes in the moving factor parameters required for computing the OTP for
 * OATH time based tokens and returns the corresponding OTP.
 * rt is the relative time, difference between current time and starting time
 * ts is the time elapse contributed step for example 30 seconds as 1 time step
 *
 * returns -1 if the parameters provided are incorrect.
 */
int64_t getHOTPMovingFactor(int rt, int ts);


