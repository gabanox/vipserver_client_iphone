
#include "base64.h"
#include <stdio.h>
#import <stdlib.h>
#include <string.h>

#define CR	0x0d	/* \r */
#define LF	0x0a	/* \n */
#define LINELENGTH	64

char table[] =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

static int EncodeBase64(ITEM *output, ITEM input);
static int DecodeBase64(ITEM *output, ITEM input);
void DisplayHex(const char *Msg, unsigned char *buffer, int size);

/*
 * Base64Alloc
 * - Base64 encode binary data
 * - allocate space for the return data
 */
int Base64Alloc (ITEM *base64data, ITEM input)
{
  int num;
  int status = 0;

  num = (input.len / 3 + 1) * 4;
  base64data->len = num + (num / LINELENGTH + 1) * 2 + 3;
  base64data->data = (unsigned char *) malloc(base64data->len);
  if (!base64data->data)
    return (-1);

  status = EncodeBase64 (base64data, input);

  if (status != 0) {
    free (base64data->data);
    base64data->len = 0;
    base64data->data = 0;
  }
  return (status);
}

/*
 * Base64StringAlloc
 * - Base64 encode binary data
 * - allocate space for the return data
 * - Use calloc() so that it is NULL terminated
 */
int Base64StringAlloc (char **base64Str, ITEM input)
{
	int num;//, len;
  ITEM output;
  int status = 0;

  num = (input.len / 3 + 1) * 4;
  output.len = num + (num / LINELENGTH + 1) * 2 + 5;
  output.data = (unsigned char *) calloc(output.len, 1);
  if (!output.data)
    return (-1);

  status = EncodeBase64 (&output, input);
  if (status != 0) {
    free (output.data);
  }
  *base64Str = (char *)output.data;
  return (status);
}

static int EncodeBase64(ITEM *output, ITEM input)
{
  unsigned char indices[4];	/* Four byte out stream indices */
  unsigned int fourbyte = 0;	/* Constructed 4 byte integer */
  unsigned char c;
  int i_idx = 0, o_idx = 0;
  int pos3 = 0;		/* current 3 byte position */
  int numchar_line = 0;	/* number chars on current line */
  int i;
  

  for (; i_idx < input.len; i_idx++) {
    c = input.data[i_idx];

    if (pos3 < 3) {
      pos3++;
      fourbyte <<= 8;
      fourbyte += c;
      continue;
    }

    for (i = 0; i < 4; i++) {
      indices[i] = fourbyte & 0x3f;
      fourbyte >>= 6;
    }

    for (i = 3; i >= 0; i--) {
      output->data[o_idx] = table[indices[i]];
      o_idx++;
    }

    numchar_line += 4;
    fourbyte = c;
    pos3 = 1;

    if (numchar_line >= LINELENGTH) {
      output->data[o_idx] = CR;
      o_idx++;
      output->data[o_idx] = LF;
      o_idx++;
      numchar_line = 0;
    }
  }
  if (pos3 > 0) {
    if (pos3 == 1)
      fourbyte <<= 16;
    else if (pos3 == 2) 
      fourbyte <<= 8;

    for (i = 0; i < 4; i++) {
      indices[i] = fourbyte & 0x3f;
      fourbyte >>= 6;
    }

    if (pos3 == 1)
      indices[0] = indices[1] = 64;
    else if (pos3 == 2)
      indices[0] = 64;

    for (i = 3; i >= 0; i--) {
      output->data[o_idx] = table[indices[i]];
      o_idx++;
    }
  }
  output->data[o_idx] = CR;
  o_idx++;
  output->data[o_idx] = LF;
  o_idx++;

  if (o_idx <= output->len) {
    output->len = o_idx;
  }
  else {  
    return -1;
  }
  return 0;
}

int UnBase64Alloc (ITEM *data, ITEM base64Block)
{
  int status = 0;

  data->len = (base64Block.len / 4 + 2) * 3 + 3;
  data->data = (unsigned char *) malloc(data->len);
  if (!data->data)
    return (-1);

  status = DecodeBase64(data, base64Block);

  /* if DecodeBase64 fails, make sure to free the allocated memory before return */
  if (status) {
    free(data->data);
    data->len = 0;
    data->data = 0;
  }
  return(status);
}

static int DecodeBase64(ITEM *output, ITEM input)
{
  unsigned int threebyte,	/* Constructed 3 byte integer */
	 tmpnum;
  unsigned char decodedbytes[4];
  int i_idx = 0, o_idx = 0;
  int nbyte3;		/* number of bytes (up to 3) to process */
  char *current;	/* current input character position */
  char *cp;
  int len;
  int i;
 

  len = input.len;
  for (; i_idx < len; i_idx += 4) {
    if ((input.data[i_idx] == CR) || (input.data[i_idx] == LF)) {
      if ((i_idx + 1) == len)
	break;
      i_idx ++;
    }
    if ((input.data[i_idx] == CR) || (input.data[i_idx] == LF)) {
      if ((i_idx + 1) == len)
        break;
      i_idx ++;
    }
    if ((input.data[i_idx] == CR) || (input.data[i_idx] == LF)) {
      if ((i_idx + 1) == len)
        break;
      i_idx ++;
    }
    if ((input.data[i_idx] == CR) || (input.data[i_idx] == LF)) {
      if ((i_idx + 1) == len)
        break;
      i_idx ++;
    }

    threebyte = 0;
    nbyte3 = 3;

    current = (char *) input.data + i_idx;
    if (current[2] == '=')
      nbyte3 = 1;
    else if (current[3] == '=')
      nbyte3 = 2;

    for (i = 0; i <= nbyte3; i++) {
      if ((cp = strchr(table, current[i])) == NULL) {
            return(-1);
      }
      tmpnum = cp - table;
      tmpnum <<= (3 - i) * 6;
      threebyte += tmpnum;
    }
    for (i = 2; i >= 0; i--) {
      decodedbytes[i] = threebyte & 255;
      threebyte >>= 8;
    }

    for (i = 0; i < nbyte3; i++)
      output->data[o_idx+i] = decodedbytes[i];
    o_idx += nbyte3;

    if (nbyte3 < 3)	/* No more data */
        break;
  }

  if (o_idx <= output->len) {
    output->len = o_idx;
  }
  else {  
    
    return -1;
  }
  return 0;
}

void DisplayHex(const char *Msg, unsigned char *buffer, int size)
{
    int i;

    fprintf(stdout, "%s (%d) = \n", Msg, size);
    for (i = 0; i < size; i++)
    {
        fprintf(stdout, "%02x", buffer[i]);
        if ((i & 0x1f) == 0x1f)
            printf("\n");
    }
    fprintf(stdout, "\n");
    fflush(stdout);
}
