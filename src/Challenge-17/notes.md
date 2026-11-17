RLP looks at the first byte to know what to expect:

First Byte Range	What It Means	                        Example
0x00 - 0x7f	        A single number (0 to 127)	            0x2a = number 42
0x80 - 0xb7	        A short string/text (0 to 55 bytes)	    0x83 + "dog"
0xb8 - 0xbf	        A long string (56+ bytes)	            0xb8 + length + data
0xc0 - 0xf7	        A list (0 to 55 bytes total)	        0xc0 + length + items
0xf8 - 0xff	        A long list (56+ bytes)	                0xf8 + length + items
