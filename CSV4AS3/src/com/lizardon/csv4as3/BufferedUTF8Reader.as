/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 *       *******************************************************
 *         This software is a derivative work of the original  
 *         Apache Software Foundation project Commons CSV.     
 *         It has been ported from the original Java code      
 *         to Actionscript by Lizardon Software in 2013        
 *       *******************************************************
 */

package com.lizardon.csv4as3
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class BufferedUTF8Reader
	{
		protected static var newLineCode:Number = '\n'.charCodeAt();
		
		public static const BYTE_TYPE_LEADING_1:int = 0;
		public static const BYTE_TYPE_LEADING_2:int = -64;
		public static const BYTE_TYPE_LEADING_3:int = -32;
		public static const BYTE_TYPE_LEADING_4:int = -16;
		public static const BYTE_TYPE_LEADING_5:int = -8
		public static const BYTE_TYPE_LEADING_6:int = -4
		public static const BYTE_TYPE_CONTINUATION:int = -128;
		
		public static const MASK_LEADING_1:int = -128;    // 10000000
		public static const MASK_LEADING_2:int = -32;     // 11100000
		public static const MASK_LEADING_3:int = -16;     // 11110000
		public static const MASK_LEADING_4:int = -8;      // 11111000
		public static const MASK_LEADING_5:int = -4;      // 11111100
		public static const MASK_LEADING_6:int = -2;      // 11111110
		public static const MASK_CONTINUATION:int = -64;  // 11000000
		
		protected static function getUTF8ByteType(byte:int):int
		{
			if((byte & MASK_CONTINUATION) == BYTE_TYPE_CONTINUATION)
			{
				return 1;
			}
			else if((byte & MASK_LEADING_1) == BYTE_TYPE_LEADING_1)
			{
				return 1;
			}
			else if((byte & MASK_LEADING_2) == BYTE_TYPE_LEADING_2)
			{
				return 2;
			}
			else if((byte & MASK_LEADING_3) == BYTE_TYPE_LEADING_3)
			{
				return 3;
			}
			else if((byte & MASK_LEADING_4) == BYTE_TYPE_LEADING_4)
			{
				return 4;
			}
			else if((byte & MASK_LEADING_5) == BYTE_TYPE_LEADING_5)
			{
				return 5;
			}
			else if((byte & MASK_LEADING_6) == BYTE_TYPE_LEADING_6)
			{
				return 6;
			}
			
			return 1;
		}
		
		
		protected var _input:IDataInput;
		protected var _bufferSize:Number; // buffer length in bytes
		
		protected var _stringBuffer:StringBuilder = new StringBuilder();
		protected var _stringBufferPos:Number = 0;
		
		protected var _byteBuffer:ByteArray = new ByteArray();
		protected var _tailBytes:ByteArray = new ByteArray();
		
		protected var _currentLineNumber:Number = 0;
		
		protected var _lastChar:Number = Constants.UNDEFINED;
		protected var _eolCounter:Number = 0;
		
		public function BufferedUTF8Reader(input:IDataInput, bufferSize:Number=262144)
		{
			this._input = input;
			this._bufferSize = bufferSize;
		}
		
		
		protected function get remainingBufferChars():uint
		{
			return _stringBuffer.length - _stringBufferPos;
		}
		
		protected function get bytesToRead():uint 
		{
			return Math.min(_bufferSize, _input.bytesAvailable);
		}
		
		protected function refillBuffer():void 
		{
			_byteBuffer.clear();
			
			_stringBuffer.reset();
			_stringBufferPos = 0;
			
			// add tail bytes
			if(_tailBytes.length > 0)
			{
				_byteBuffer.writeBytes(_tailBytes);
			}
			
			var bytesToReadTemp:uint = bytesToRead;
			_input.readBytes(_byteBuffer, _tailBytes.length, bytesToReadTemp);
			_tailBytes.clear();
			
			var lastPosition:uint = 0;
			var nextPosition:uint = 0;
			var byte:int;
			while(nextPosition < _byteBuffer.length)
			{
				_byteBuffer.position = nextPosition;
				byte = _byteBuffer.readByte();
				lastPosition = nextPosition;
				nextPosition = nextPosition + getUTF8ByteType(byte);
			}
			
			// find tail bytes
			if(nextPosition > _byteBuffer.length)
			{
				_byteBuffer.position = lastPosition;
				_byteBuffer.readBytes(_tailBytes);
			}
			
			_byteBuffer.position = 0;

			// add coorect number of bytes to _buffer with readUTFByte
			_stringBuffer.appendString(_byteBuffer.readUTFBytes(_byteBuffer.length - _tailBytes.length));
		}
		

		
		// an array of charCode Number
		public function read(out:Array, off:Number, len:Number):Number
		{
			if(!ready())
			{
				_lastChar == Constants.END_OF_STREAM;
				return -1;
			}
			
			var char:Number;
			
			for(var i:int=0; i<len && ready(); i++)
			{				
				if(remainingBufferChars < 1)
				{
					refillBuffer();
				}
				
				char = _stringBuffer.buffer[_stringBufferPos];
				_stringBufferPos++;
				
				if(char == Constants.LF && _lastChar != Constants.CR) // \n, \r, \r\n
				{
					_eolCounter++;
				}
				else if (char == Constants.CR)
				{
					_eolCounter++;
				}
				
				out[off+i] = char;
				_lastChar == char;
			}
			
			return i;
		}
		
		// Returns one charactor string or -1 if end of input has been reached.
		public function readChar():Number
		{
			if(!ready())
			{
				_lastChar == Constants.END_OF_STREAM;
				return -1;
			}
			
			if(remainingBufferChars < 1)
			{
				refillBuffer();
			}
			
			var current:Number = _stringBuffer.buffer[_stringBufferPos];
			_stringBufferPos++;
			
			if(current == Constants.CR || (current == Constants.LF && _lastChar != Constants.CR))
			{
				_eolCounter++;
			}
			
			_lastChar = current;
			return current;
		}
		
		//
		public function readLine():String
		{
			if(!ready())
			{
				_lastChar == Constants.END_OF_STREAM;
				return null;
			}
			
			var sb:StringBuilder = new StringBuilder();
			var char:Number;
			
			for(var i:int=0;ready();i++)
			{
				if(remainingBufferChars < 1)
				{
					refillBuffer();
				}

				char = _stringBuffer.buffer[_stringBufferPos];
				
				if(i>0 && _lastChar == Constants.CR && char != Constants.LF)
				{
					break;
				}
				
				_stringBufferPos++;
				
				if(char == Constants.LF) // \n, \r, \r\n
				{
					if(_lastChar != Constants.CR)
					{
						_eolCounter++;
					}
					_lastChar == Constants.LF;
					break;
				}
				else if (char == Constants.CR)
				{
					_eolCounter++;
					_lastChar == Constants.CR;
					continue;
				}
				else
				{
					sb.appendChar(char);
					_lastChar == char;
					continue;
				}
			}
			
			return sb.toString();
		}
		
		public function skip(n:Number):Number
		{
			if(!ready())
			{
				_lastChar == Constants.END_OF_STREAM;
				return -1;
			}
			
			for(var i:int=0; i<n; i++)
			{
				if(readChar() == -1)
				{
					break;
				}
			}
			
			return i;
		}
		
		public function lookAhead():Number
		{
			if(!ready())
			{
				return -1;
			}
			
			if(remainingBufferChars < 1)
			{
				refillBuffer();
			}
			
			return _stringBuffer.buffer[_stringBufferPos];
		}
		
		public function ready():Boolean
		{
			return remainingBufferChars > 0 || _input.bytesAvailable > 0;
		}

		public function get lastChar():Number
		{
			return _lastChar;
		}

		public function get currentLineNumber():Number
		{			
			if(lastChar == Constants.CR || lastChar == Constants.LF ||  
				lastChar == Constants.UNDEFINED || lastChar == Constants.END_OF_STREAM)
			{
				return _eolCounter;
			}
			
			return _eolCounter + 1;
		}
	}
}