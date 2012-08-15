

typedef struct {
	unsigned char *data;
	unsigned int len;
} ITEM;


/* Base64Alloc
 *      Encodes binary data into base64 format.
 */
int Base64Alloc (
				 ITEM *,
				 ITEM
				 );

/* Base64StringAlloc
 *      Encodes binary data into base64 format string.
 */
int Base64StringAlloc (
					   char **,
					   ITEM
					   );

/* UnBase64Alloc
 *      Decodes data in base64 format into binary format.
 */
int UnBase64Alloc (
				   ITEM *,
				   ITEM
				   );

