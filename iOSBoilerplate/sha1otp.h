    int             hmac_sha1_otp_len(int param);
    int             hmac_sha1_otp(int param, const char * key, int key_size, int64_t moving_factor, char *response, int response_bytes);


